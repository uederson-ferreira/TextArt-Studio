import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Overlay de controles exibido sobre o elemento selecionado no canvas.
class ElementControlsOverlay extends StatelessWidget {
  final String elementId;
  final VoidCallback onDelete;
  final VoidCallback? onDuplicate;
  /// Called with the cumulative drag delta (dx + dy) during resize.
  final void Function(double delta)? onResize;

  const ElementControlsOverlay({
    super.key,
    required this.elementId,
    required this.onDelete,
    this.onDuplicate,
    this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Selection border — not interactive
          Positioned(
            top: 18,
            left: 18,
            right: 18,
            bottom: 18,
            child: IgnorePointer(
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
          ),

          // Resize handle — bottom right
          // Uses onScaleStart/Update (NOT onPanUpdate) so it wins the scale arena
          // over the parent element's GestureDetector, preventing element drift.
          if (onResize != null)
            Positioned(
              bottom: 0,
              right: 0,
              child: _ResizeHandle(
                onResize: onResize!,
              ),
            ),

          // Duplicate handle — top right
          if (onDuplicate != null)
            Positioned(
              top: 0,
              right: 0,
              child: _TapHandle(
                color: AppColors.primary,
                icon: Icons.copy,
                onTap: onDuplicate!,
              ),
            ),

          // Delete handle — top left
          Positioned(
            top: 0,
            left: 0,
            child: _TapHandle(
              color: Colors.red,
              icon: Icons.close,
              onTap: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TAP HANDLE (delete / duplicate)
// ---------------------------------------------------------------------------

class _TapHandle extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _TapHandle({
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: AppSizes.handleSize,
        height: AppSizes.handleSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// RESIZE HANDLE (bottom-right drag)
// ---------------------------------------------------------------------------

class _ResizeHandle extends StatelessWidget {
  final void Function(double delta) onResize;

  const _ResizeHandle({required this.onResize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Using onScaleStart/Update (not onPanUpdate) means this GestureDetector
      // competes in the *scale* arena and wins over the parent element widget,
      // preventing the parent from also moving/scaling the element while resizing.
      onScaleStart: (_) {},
      onScaleUpdate: (details) {
        final delta =
            details.focalPointDelta.dx + details.focalPointDelta.dy;
        onResize(delta);
      },
      child: Container(
        width: AppSizes.handleSize,
        height: AppSizes.handleSize,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Icon(Icons.open_in_full, color: AppColors.primary, size: 16),
      ),
    );
  }
}
