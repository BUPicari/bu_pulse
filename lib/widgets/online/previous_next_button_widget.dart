import 'package:flutter/material.dart';

import 'package:bu_pulse/data/models/online/questions_model.dart';
import 'package:bu_pulse/data/models/online/surveys_model.dart';
import 'package:bu_pulse/helpers/variables.dart';
import 'package:bu_pulse/screens/online/review_screen.dart';
import 'package:bu_pulse/screens/online/survey_done_screen.dart';

class PreviousNextButtonWidget extends StatelessWidget {
  final int index;
  final Questions question;
  final Surveys survey;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const PreviousNextButtonWidget({
    super.key,
    required this.index,
    required this.question,
    required this.survey,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 17),
      SizedBox(
        child: SizedBox(
          height: 50,
          child: _actions(context),
        ),
      ),
    ]);
  }

  Widget _actions(context) {
    if (survey.questionnaires?.last == question) {
      return Row(children: [
        _buildPrevBtn(context),
        const SizedBox(width: 10),
        _buildReviewBtn(context),
        const SizedBox(width: 10),
        _buildSubmitBtn(context),
      ]);
    }

    return Row(children: [
      _buildPrevBtn(context),
      const Spacer(),
      _buildNextBtn(context),
    ]);
  }

  Widget _buildPrevBtn(context) {
    bool condition = question == survey.questionnaires?.first;
    var color = condition ? AppColor.secondary : AppColor.primary;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          condition ? null : onPressedPrev(index);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'Prev',
          style: TextStyle(
            color: AppColor.subPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewBtn(context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewScreen(
                survey: survey,
                addresses: addresses,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'Review',
          style: TextStyle(
            color: AppColor.subPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitBtn(context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurveyDoneScreen(
                survey: survey,
                addresses: addresses,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'Submit',
          style: TextStyle(
            color: AppColor.subPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNextBtn(context) {
    bool condition = question == survey.questionnaires?.last;
    var color = condition ? AppColor.secondary : AppColor.primary;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          condition ? null : onPressedNext(index);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(33),
          ),
        ),
        child: Text(
          'Next',
          style: TextStyle(
            color: AppColor.subPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
