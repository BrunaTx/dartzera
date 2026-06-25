import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/subaccount_entity.dart';

class AccountSummaryCard extends StatelessWidget {
  final SubAccount subAccount;

  const AccountSummaryCard({super.key, required this.subAccount});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.secondary, colors.primary],
          ),
        ),
        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subAccount.displayName.isNotEmpty
                          ? subAccount.displayName
                          : subAccount.name,
                      style: context.textStyles.headlineLarge
                          ?.bold
                          .withColor(colors.onSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Lv. ${subAccount.level}',
                    style: context.textStyles.headlineSmall
                        ?.bold
                        .withColor(colors.onSecondary),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    icon: Icons.bolt,
                    label: 'Energia',
                    value: subAccount.energy.toString(),
                    color: Colors.greenAccent,
                  ),
                  _StatItem(
                    icon: Icons.diamond,
                    label: 'Gemas',
                    value: subAccount.gems.toString(),
                    color: Colors.lightBlueAccent,
                  ),
                  _StatItem(
                    icon: Icons.attach_money,
                    label: 'Gold',
                    value: subAccount.gold.toStringAsFixed(0),
                    color: Colors.amberAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSecondary;

    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: context.textStyles.labelLarge?.semiBold.withColor(textColor),
        ),
        Text(label, style: context.textStyles.bodySmall?.withColor(textColor)),
      ],
    );
  }
}
