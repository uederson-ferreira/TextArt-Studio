import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/editor_bloc.dart';
import '../bloc/editor_event.dart';
import '../bloc/editor_state.dart';
import '../widgets/canvas_widget.dart';
import '../widgets/editor_toolbar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection_container.dart';
import '../../../export/domain/usecases/export_to_image.dart';
import '../../../export/presentation/widgets/export_options_sheet.dart';
import '../../../export/presentation/widgets/export_web_helper_stub.dart'
    if (dart.library.html) '../../../export/presentation/widgets/export_web_helper_web.dart';
import '../../../export/presentation/widgets/mobile_export_stub.dart'
    if (dart.library.io) '../../../export/presentation/widgets/mobile_export_io.dart';

class EditorPage extends StatelessWidget {
  final String? projectId;

  const EditorPage({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EditorBloc>()
        ..add(EditorLoadProject(projectId: projectId)),
      child: _EditorView(projectId: projectId),
    );
  }
}

class _EditorView extends StatefulWidget {
  final String? projectId;

  const _EditorView({this.projectId});

  @override
  State<_EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<_EditorView> {
  final _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          // Auto-save on back navigation
          context.read<EditorBloc>().add(const EditorSaveProject());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: _buildCanvas(),
            ),
            EditorBottomToolbar(
              onExport: () => _showExportSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          context.read<EditorBloc>().add(const EditorSaveProject());
          context.pop();
        },
      ),
      title: BlocBuilder<EditorBloc, EditorState>(
        builder: (context, state) {
          return Text(
            state.project.name,
            style: AppTypography.titleMedium(),
          );
        },
      ),
      actions: [
        // Undo
        BlocBuilder<EditorBloc, EditorState>(
          buildWhen: (prev, curr) => prev.canUndo != curr.canUndo,
          builder: (context, state) {
            return IconButton(
              icon: const Icon(Icons.undo),
              onPressed: state.canUndo
                  ? () => context.read<EditorBloc>().add(const EditorUndo())
                  : null,
            );
          },
        ),
        // Redo
        BlocBuilder<EditorBloc, EditorState>(
          buildWhen: (prev, curr) => prev.canRedo != curr.canRedo,
          builder: (context, state) {
            return IconButton(
              icon: const Icon(Icons.redo),
              onPressed: state.canRedo
                  ? () => context.read<EditorBloc>().add(const EditorRedo())
                  : null,
            );
          },
        ),
        // Save
        BlocBuilder<EditorBloc, EditorState>(
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (context, state) {
            final saving = state.status == EditorStatus.saving;
            return IconButton(
              icon: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save_outlined),
              onPressed: saving
                  ? null
                  : () {
                      context
                          .read<EditorBloc>()
                          .add(const EditorSaveProject());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Projeto salvo!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
            );
          },
        ),
        const SizedBox(width: AppSizes.space8),
      ],
    );
  }

  Widget _buildCanvas() {
    return Container(
      margin: const EdgeInsets.all(AppSizes.space8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.dividerDark),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: CanvasWidget(repaintKey: _repaintKey),
      ),
    );
  }

  Future<void> _showExportSheet(BuildContext context) async {
    final bloc = context.read<EditorBloc>();

    // 1. Show sheet and wait for user to confirm settings
    final request = await showModalBottomSheet<ExportRequest>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExportOptionsSheet(
        repaintKey: _repaintKey,
        isPremium: false,
      ),
    );

    if (request == null || !context.mounted) return;

    // 2. Sheet is now CLOSED → canvas is fully visible and will repaint
    bloc.add(EditorSetExporting(true, transparent: request.transparent));

    // 3. Wait for the canvas to repaint with the new state
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;

    // 4. Capture
    final bytes = await ExportToImage(isPremium: false).call(
      repaintKey: _repaintKey,
    );

    // 5. Restore canvas state
    bloc.add(const EditorSetExporting(false));

    if (bytes == null || bytes.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao capturar imagem.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // 6. Save / Share / Download
    try {
      if (kIsWeb) {
        await downloadImageOnWeb(
            bytes, 'textart_${DateTime.now().millisecondsSinceEpoch}.png');
      } else if (request.share) {
        await shareImage(bytes);
      } else {
        final granted = await requestPhotoPermission();
        if (!granted) throw 'Permissão de Galeria negada. Vá em Ajustes.';
        await saveToGallery(bytes);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(kIsWeb
                ? 'Download iniciado!'
                : (request.share
                    ? 'Processo finalizado!'
                    : 'Imagem salva na Galeria!')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
