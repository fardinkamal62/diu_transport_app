import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? hintText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    required this.controller,
    this.hintText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  late Color _borderColor;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _borderColor = _focusNode.hasFocus
          ? Theme.of(context).colorScheme.primary
          : Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelMedium!.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword,
          focusNode: _focusNode, // Assign focus node
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: theme.colorScheme.primary),
            hintText: widget.hintText ?? "Enter your ${widget.label}",
          ),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}