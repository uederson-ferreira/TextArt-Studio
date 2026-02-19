import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_typography.dart';

/// Botão primário com gradiente da marca (violeta → rosa).
class GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double height;
  final double? width;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.height = AppSizes.buttonHeight,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? AppColors.gradientBrand
              : const LinearGradient(
                  colors: [AppColors.surfaceHighDark, AppColors.surfaceHighDark],
                ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            minimumSize: Size(width ?? double.infinity, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
          ),
          icon: icon != null ? Icon(icon, size: AppSizes.iconSm) : const SizedBox.shrink(),
          label: Text(
            label,
            style: AppTypography.labelLarge(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
