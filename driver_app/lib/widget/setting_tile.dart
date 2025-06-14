import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.theme,
    required this.title,
    required this.leadingIcon,
    required this.onTap,
    this.trailingIcon,

  });

  final ThemeData theme;
  final String title;
  final IconData leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(leadingIcon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        trailing: trailingIcon != null
            ? Icon(trailingIcon, size: 18, color: theme.colorScheme.onSurface.withOpacity(0.6))
            : null,
        onTap: onTap
    );
  }
}