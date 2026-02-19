import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../domain/usecases/export_to_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/gradient_button.dart';

class ExportOptionsSheet extends StatefulWidget {
  final GlobalKey repaintKey;
  final bool isPremium;

  const ExportOptionsSheet({
    super.key,
    required this.repaintKey,
    this.isPremium = false,
  });

  @override
  State<ExportOptionsSheet> createState() => _ExportOptionsSheetState();
}

class _ExportOptionsSheetState extends State<ExportOptionsSheet> {
  bool _isExporting = false;
  Uint8List? _preview;

  @override
  void initState() {
    super.initState();
    _generatePreview();
  }

  Future<void> _generatePreview() async {
    final bytes = await ExportToImage(isPremium: widget.isPremium).call(
      repaintKey: widget.repaintKey,
      pixelRatio: 1.0,
    );
    if (mounted) setState(() => _preview = bytes);
  }

  Future<void> _export({bool share = false}) async {
    setState(() => _isExporting = true);

    final bytes = await ExportToImage(isPremium: widget.isPremium).call(
      repaintKey: widget.repaintKey,
    );

    if (bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao exportar imagem')),
        );
      }
      setState(() => _isExporting = false);
      return;
    }

    if (share) {
      await _shareImage(bytes);
    } else {
      await _saveToGallery(bytes);
    }

    setState(() => _isExporting = false);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _shareImage(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/textart_export.png');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: 'Criado com TextArt Studio',
    );
  }

  Future<void> _saveToGallery(Uint8List bytes) async {
    try {
      // Save to app documents dir (gallery_saver approach)
      final dir = await getApplicationDocumentsDirectory();
      final filename =
          'textart_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imagem salva em $filename')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar imagem')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSizes.space16,
        AppSizes.space16,
        AppSizes.space16,
        MediaQuery.of(context).viewInsets.bottom + AppSizes.space24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSizes.space16),
            decoration: BoxDecoration(
              color: AppColors.dividerDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Text('Exportar Imagem', style: AppTypography.titleLarge()),
          const SizedBox(height: AppSizes.space16),

          // Preview
          if (_preview != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: Image.memory(
                _preview!,
                height: 200,
                fit: BoxFit.contain,
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceHighDark,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),

          if (!widget.isPremium) ...[
            const SizedBox(height: AppSizes.space12),
            Container(
              padding: const EdgeInsets.all(AppSizes.space8),
              decoration: BoxDecoration(
                color: AppColors.warningBackground,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.warning, size: 16),
                  const SizedBox(width: AppSizes.space8),
                  Expanded(
                    child: Text(
                      'Plano free inclui marca d\'água. Faça upgrade para exportar sem.',
                      style: AppTypography.labelSmall(
                          color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSizes.space20),

          if (_isExporting)
            const CircularProgressIndicator()
          else
            Column(
              children: [
                GradientButton(
                  label: 'Salvar na Galeria',
                  icon: Icons.download,
                  onPressed: () => _export(),
                ),
                const SizedBox(height: AppSizes.space12),
                OutlinedButton.icon(
                  onPressed: () => _export(share: true),
                  icon: const Icon(Icons.share),
                  label: const Text('Compartilhar'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
