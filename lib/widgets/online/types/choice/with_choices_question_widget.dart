import 'package:flutter/material.dart';

import 'package:bu_pulse/data/models/online/answer_model.dart';
import 'package:bu_pulse/data/models/online/questions_model.dart';
import 'package:bu_pulse/data/models/online/surveys_model.dart';
import 'package:bu_pulse/widgets/online/previous_next_button_widget.dart';
import 'package:bu_pulse/widgets/online/types/choice/choice_widget.dart';

class WithChoicesQuestionWidget extends StatelessWidget {
  final int index;
  final Surveys survey;
  final Questions question;
  final String subText;
  final ValueChanged<Answer> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const WithChoicesQuestionWidget({
    super.key,
    required this.index,
    required this.survey,
    required this.question,
    required this.subText,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ChoiceWidget(
              question: question,
              onSetResponse: onSetResponse,
              subText: subText,
            ),
          ),
          PreviousNextButtonWidget(
            index: index,
            question: question,
            survey: survey,
            onPressedPrev: onPressedPrev,
            onPressedNext: onPressedNext,
            addresses: addresses,
          ),
        ],
      ),
    );
  }
}
