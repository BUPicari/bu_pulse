import 'package:flutter/material.dart';

import 'package:bu_pulse/data/models/offline/questionnaire.dart';
import 'package:bu_pulse/data/models/offline/response.dart';
import 'package:bu_pulse/widgets/offline/types/choice/local_choice_type_widget.dart';
import 'package:bu_pulse/widgets/offline/types/datepicker/local_datepicker_type_widget.dart';
import 'package:bu_pulse/widgets/offline/types/dropdown/local_dropdown_type_widget.dart';
import 'package:bu_pulse/widgets/offline/types/openended/local_open_ended_type_widget.dart';
import 'package:bu_pulse/widgets/offline/types/rating/local_rating_type_widget.dart';
import 'package:bu_pulse/widgets/unkown_question_type_widget.dart';

class LocalQuestionnaireWidget extends StatelessWidget {
  final List<Questionnaire> questionnaires;
  final PageController pageController;
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const LocalQuestionnaireWidget({
    super.key,
    required this.questionnaires,
    required this.pageController,
    required this.onChangedPage,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: onChangedPage,
      controller: pageController,
      itemCount: questionnaires.length,
      itemBuilder: (context, index) {
        final questionnaire = questionnaires[index];
        return _buildQuestionnaire(index: index, questionnaire: questionnaire);
      },
    );
  }

  Widget _buildQuestionnaire({
    required int index,
    required Questionnaire questionnaire,
  }) {
    switch (questionnaire.type) {
      case "multipleChoice":
        String subText = questionnaire.configs.multipleAnswer ?
          'Please select all that apply' :
          '';
        return LocalChoiceTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          subText: subText,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "openEnded":
        return LocalOpenEndedTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "trueOrFalse":
        return LocalChoiceTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          subText: '',
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "rating":
        return LocalRatingTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "datepicker":
        return LocalDatePickerTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      case "dropdown":
        return LocalDropdownTypeWidget(
          index: index,
          questionnaires: questionnaires,
          questionnaire: questionnaire,
          onSetResponse: onSetResponse,
          onPressedPrev: onPressedPrev,
          onPressedNext: onPressedNext,
          addresses: addresses,
        );
      default:
        return const UnknownQuestionTypeWidget();
    }
  }
}
