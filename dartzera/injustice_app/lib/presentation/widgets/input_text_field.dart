import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';

class InputTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? prefixIcon;

  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Key? fieldKey;

  final bool enabled;
  final bool obscureText;

  const InputTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.enabled = true,
    this.fieldKey,
    this.obscureText = false,
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(AppRadius.md);

    return TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: widget.obscureText ? _obscureText : false,

      style: TextStyle(color: colorScheme.primary),

      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint ?? widget.label,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        labelStyle: TextStyle(color: colorScheme.primary),

        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          backgroundColor: colorScheme.onSecondary,
        ),

        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: colorScheme.primary)
            : null,

        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: colorScheme.primary,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,

        filled: true,
        fillColor: colorScheme.onSecondary,

        border: OutlineInputBorder(borderRadius: borderRadius),

        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.primary),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        errorStyle: TextStyle(
          color: colorScheme.tertiary,
          fontWeight: FontWeight.bold,
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),

      validator: widget.validator,
    );
  }
}
