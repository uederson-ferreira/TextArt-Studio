import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Overlay de controles exibido sobre o elemento selecionado no canvas.
/// Mostra handle de delete e borda de seleção.
class ElementControlsOverlay extends StatelessWidget {
  final String elementId;
  final VoidCallback onDelete;

  const ElementControlsOverlay({
    super.key,
    required this.elementId,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Selection border
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusXs),
              ),
            ),
          ),

          // Delete handle — top right corner
          Positioned(
            top: -12,
            right: -12,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: AppSizes.handleSize,
                height: AppSizes.handleSize,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
