import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_typography.dart';
import 'gradient_button.dart';

/// Overlay de blur + lock para conteúdo premium bloqueado.
class PremiumLockOverlay extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final VoidCallback? onUpgrade;

  const PremiumLockOverlay({
    super.key,
    required this.child,
    this.title = 'Recurso Premium',
    this.description = 'Faça upgrade para desbloquear',
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: AppColors.premiumLockOverlay,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientPremium,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space16),
                    Text(
                      title,
                      style: AppTypography.titleMedium(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.space8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.space32),
                      child: Text(
                        description,
                        style: AppTypography.bodySmall(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSizes.space20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.space32),
                      child: GradientButton(
                        label: 'Fazer Upgrade',
                        icon: Icons.star,
                        onPressed: onUpgrade,
                        height: AppSizes.buttonHeightSm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
