import 'package:flutter/material.dart';

class QuestionSubtextWidget extends StatelessWidget {
  final String subText;

  const QuestionSubtextWidget({
    super.key,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    if (subText != '') {
      return Column(children: [
        const SizedBox(height: 10),
        Text(
          subText,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
        ),
      ]);
    }

    return const Column();
  }
}
