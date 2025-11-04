import 'package:flutter/material.dart';

import '../utils/app_assets.dart';
import '../utils/theme/colors_manager.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double fontSize;
  final bool showIcon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.fontSize,
    this.showIcon = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = onPressed == null || isLoading
        ? theme.colorScheme.primary.withValues(alpha: 0.4)
        : theme.colorScheme.primary.withAlpha(200);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            minimumSize: Size(150, 60),
          ),
          child: isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
              : Text(
            label,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cormorant',
              color: ColorsManager.white,
            ),
          ),
        ),


        if (showIcon && !isLoading)
          Positioned(
            top: -33,
            left: -27,
              child: Image.asset(
              AppAssets.designButtonIcon,
              color: theme.colorScheme.primary,
              height: 90,
            ),
          ),
      ],
    );
  }
}
