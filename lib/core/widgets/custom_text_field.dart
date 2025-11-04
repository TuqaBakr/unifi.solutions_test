import 'package:flutter/material.dart';
import '../utils/theme/colors_manager.dart';
import '../utils/theme/style_manager.dart';
import '../utils/theme/values_manager.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onTap,
    this.borderColor,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final String? Function(String?)? onFieldSubmitted;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;
  final Color? borderColor; // ✅

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues (alpha: 0.5),
            spreadRadius: 1.5,
            blurRadius: 7,
            offset: const Offset(0, 5),
          )
        ],
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(22),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        focusNode: _focusNode,
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorsManager.black,
        ),
        decoration: _buildInputDecoration(isFocused),
      ),
    );
  }

  InputDecoration _buildInputDecoration(bool isFocused) {
    final theme = Theme.of(context);

    final color = isFocused
            ? (widget.borderColor ?? theme.colorScheme.primary)
            : Colors.transparent;

    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      alignLabelWithHint: true,
      labelText: widget.label,
      hintText: widget.label,
      hintStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w200,
        fontFamily: 'Poppins',
      ),
      labelStyle: theme.textTheme.bodySmall?.copyWith(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.w200,
        fontFamily: 'Poppins',
      ),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: StyleManager.buildCustomBorder(color: color),
      errorBorder: StyleManager.buildCustomBorder(color: ColorsManager.red),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: theme.textTheme.bodySmall?.copyWith(
        color: Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p30,
        vertical: AppPadding.p20,
      ),
      isCollapsed: true,
    );
  }
}

