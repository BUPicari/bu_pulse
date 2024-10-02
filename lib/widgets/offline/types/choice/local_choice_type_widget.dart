import 'package:flutter/material.dart';

import 'package:bu_pulse/data/models/offline/questionnaire.dart';
import 'package:bu_pulse/data/models/offline/response.dart';
import 'package:bu_pulse/widgets/offline/local_goto_widget.dart';
import 'package:bu_pulse/widgets/offline/types/choice/local_choice_widget.dart';

class LocalChoiceTypeWidget extends StatelessWidget {
  final int index;
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final String subText;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const LocalChoiceTypeWidget({
    super.key,
    required this.index,
    required this.questionnaires,
    required this.questionnaire,
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
            child: LocalChoiceWidget(
              questionnaire: questionnaire,
              onSetResponse: onSetResponse,
              subText: subText,
            ),
          ),
          LocalGotoWidget(
            index: index,
            questionnaires: questionnaires,
            questionnaire: questionnaire,
            onPressedPrev: onPressedPrev,
            onPressedNext: onPressedNext,
            addresses: addresses,
          ),
        ],
      ),
    );
  }
}
