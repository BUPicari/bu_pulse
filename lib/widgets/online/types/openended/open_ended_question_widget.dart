import 'package:flutter/material.dart';

import 'package:bu_pulse/data/models/online/answer_model.dart';
import 'package:bu_pulse/data/models/online/questions_model.dart';
import 'package:bu_pulse/data/models/online/surveys_model.dart';
import 'package:bu_pulse/helpers/functions.dart';
import 'package:bu_pulse/helpers/variables.dart';
import 'package:bu_pulse/widgets/online/previous_next_button_widget.dart';
import 'package:bu_pulse/widgets/question_text_widget.dart';
import 'package:bu_pulse/widgets/online/record_answer_widget.dart';

class OpenEndedQuestionWidget extends StatefulWidget {
  final int index;
  final Surveys survey;
  final Questions question;
  final ValueChanged<Answer> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const OpenEndedQuestionWidget({
    super.key,
    required this.index,
    required this.survey,
    required this.question,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  });

  @override
  State<OpenEndedQuestionWidget> createState() => _OpenEndedQuestionWidgetState();
}

class _OpenEndedQuestionWidgetState extends State<OpenEndedQuestionWidget> {
  List<TextEditingController> fieldControllers = [];
  List<String> responses = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    fieldControllers = widget.question.answer?.answers.map((e)
      => TextEditingController(text: e)).toList() ?? [];
    responses = widget.question.answer?.answers ?? [];
    fieldTexts = widget.question.labels.map((label) => label.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: _buildTextFieldForms(),
          ),
          PreviousNextButtonWidget(
            index: widget.index,
            question: widget.question,
            survey: widget.survey,
            onPressedPrev: widget.onPressedPrev,
            onPressedNext: widget.onPressedNext,
            addresses: widget.addresses,
          ),
        ],
      ),
    );
  }

  Widget _recordingButton() {
    bool enableAudioRecording =
      widget.question.config.enableAudioRecording ?? false;
    bool hasInput = widget.question.hasInput ?? false;

    if (enableAudioRecording && hasInput == false) {
      return Column(
        children: [
          const SizedBox(height: 5),
          RecordAnswerWidget(
            question: widget.question,
            survey: widget.survey,
            addresses: widget.addresses,
            index: widget.index,
          ),
        ],
      );
    }

    return const Column();
  }

  Widget _buildTextFieldForms() {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      children: Functions.heightBetween(
        _buildTextField(),
        height: 5,
      ),
    );
  }

  List<Widget> _buildTextField() {
    var children = <Widget>[];

    children.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        QuestionTextWidget(
          isRequired: widget.question.config.isRequired,
          question: widget.question.question,
        ),
        _recordingButton(),
        const SizedBox(height: 12),
      ],
    ));

    widget.question.labels.map(
      (label) => children.add(Column(children: [
        TextField(
          readOnly: widget.question.hasRecording == true,
          controller: fieldControllers.isNotEmpty
            ? fieldControllers[widget.question.labels.indexOf(label)]
            : null,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColor.neutral,
                width: 2.0,
              ),
            ),
            border: const OutlineInputBorder(),
            hintText: label.name,
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(height: 2.0),
          onChanged: (value) {
            int index = widget.question.labels.indexOf(label);
            setState(() {
              responses.isNotEmpty
                ? responses[index] = value
                : responses = List.generate(widget.question.labels.length, (i) =>
                  i == index ? value : '');

              if (fieldControllers.isNotEmpty) {
                var cursorPos = fieldControllers[index].selection;
                fieldControllers[index].text = value;
                if (cursorPos.start > value.length) {
                  cursorPos = TextSelection.fromPosition(
                    TextPosition(offset: value.length));
                }
                fieldControllers[index].selection = cursorPos;
              } else {
                fieldControllers = List.generate(widget.question.labels.length, (j) => j == index
                  ? TextEditingController(text: value)
                  : TextEditingController(text: ''));
              }
            });

            if (widget.question.answer == null) {
              _setResponse();
            } else {
              widget.question.answer?.answers = responses;
            }

            if (Functions.arrDoesNotOnlyContainsEmptyString(strArr: responses)) {
              widget.question.hasRecording = false;
              widget.question.hasInput = true;
            } else {
              widget.question.hasRecording = false;
              widget.question.hasInput = false;
            }
          },
        ),
        const SizedBox(height: 5),
      ])),
    ).toList();

    return children;
  }

  void _setResponse() {
    widget.onSetResponse(Answer(
      surveyQuestion: widget.question.question,
      questionFieldTexts: fieldTexts,
      answers: responses,
      otherAnswer: '',
    ));
  }
}
