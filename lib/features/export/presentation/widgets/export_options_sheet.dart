import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../domain/usecases/export_to_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Result returned when the user confirms export from the sheet.
class ExportRequest {
  final bool share;
  final bool transparent;

  const ExportRequest({required this.share, required this.transparent});
}

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
  bool _exportTransparent = false;
  Uint8List? _preview;

  @override
  void initState() {
    super.initState();
    _generatePreview();
  }

  Future<void> _generatePreview() async {
    try {
      final bytes = await ExportToImage(isPremium: widget.isPremium).call(
        repaintKey: widget.repaintKey,
        pixelRatio: 1.0,
      );
      if (mounted) setState(() => _preview = bytes);
    } catch (e) {
      debugPrint('TextArt preview error: $e');
    }
  }

  void _confirm({required bool share}) {
    Navigator.of(context).pop(
      ExportRequest(share: share, transparent: _exportTransparent),
    );
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
              child: Image.memory(_preview!, height: 200, fit: BoxFit.contain),
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

          const SizedBox(height: AppSizes.space16),

          SwitchListTile(
            title: const Text('Fundo Transparente'),
            subtitle: const Text('Remove o fundo colorido da imagem'),
            value: _exportTransparent,
            onChanged: (v) => setState(() => _exportTransparent = v),
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
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
                      style:
                          AppTypography.labelSmall(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSizes.space20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _confirm(share: true),
                  icon: const Icon(Icons.share_outlined),
                  label: Text(kIsWeb ? 'Baixar' : 'Compartilhar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.dividerDark),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.space12),
              Expanded(
                child: GradientButton(
                  label: kIsWeb ? 'Baixar PNG' : 'Salvar na Galeria',
                  onPressed: () => _confirm(share: false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
