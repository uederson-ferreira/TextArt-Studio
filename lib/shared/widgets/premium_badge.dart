import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_typography.dart';

/// Badge dourado para indicar conteúdo premium.
class PremiumBadge extends StatelessWidget {
  final String label;
  final bool compact;

  const PremiumBadge({
    super.key,
    this.label = 'PRO',
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : AppSizes.space8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.gradientPremium,
        borderRadius: BorderRadius.circular(AppSizes.radiusCircle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: compact ? 10 : 12,
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.labelSmall(color: Colors.white).copyWith(
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
