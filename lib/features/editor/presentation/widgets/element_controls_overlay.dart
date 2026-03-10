import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Overlay de controles exibido sobre o elemento selecionado no canvas.
/// Mostra handle de delete, borda de seleção e handle de redimensionamento.
class ElementControlsOverlay extends StatelessWidget {
  final String elementId;
  final VoidCallback onDelete;
  final VoidCallback? onDuplicate;
  final GestureDragUpdateCallback? onResizeUpdate;

  const ElementControlsOverlay({
    super.key,
    required this.elementId,
    required this.onDelete,
    this.onDuplicate,
    this.onResizeUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Selection border
          Positioned(
            top: 18,
            left: 18,
            right: 18,
            bottom: 18,
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

          // Scale/Resize handle — bottom right corner
          if (onResizeUpdate != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onPanUpdate: onResizeUpdate,
                child: Container(
                  width: AppSizes.handleSize,
                  height: AppSizes.handleSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Icon(
                    Icons.open_in_full,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ),
            ),
            
          // Duplicate handle — top right corner
          if (onDuplicate != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onDuplicate,
                child: Container(
                  width: AppSizes.handleSize,
                  height: AppSizes.handleSize,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),

          // Delete handle — top left corner
          Positioned(
            top: 0,
            left: 0,
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
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
