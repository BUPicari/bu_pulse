import 'package:flutter/material.dart';

import 'package:bu_pulse/helpers/variables.dart';

class AudioButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onClicked;

  const AudioButtonWidget({
    super.key,
    required this.text,
    required this.color,
    required this.backgroundColor,
    required this.icon,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(250, 50),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(33),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 16,
        ),
      ),
      icon: Icon(
        color: AppColor.subPrimary,
        icon,
      ),
      onPressed: onClicked,
      label: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
