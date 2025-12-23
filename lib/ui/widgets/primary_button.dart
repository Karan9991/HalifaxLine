import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: loading ? const SizedBox(
        width: 22, height: 22,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      ) : Text(text),
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
      ),
    );
  }
}