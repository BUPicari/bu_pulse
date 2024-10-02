import 'package:flutter/material.dart';

import 'package:bu_pulse/data/models/offline/questionnaire.dart';
import 'package:bu_pulse/data/models/offline/response.dart';
import 'package:bu_pulse/helpers/functions.dart';
import 'package:bu_pulse/helpers/variables.dart';
import 'package:bu_pulse/widgets/offline/local_goto_widget.dart';
import 'package:bu_pulse/widgets/question_text_widget.dart';
import 'package:bu_pulse/widgets/offline/local_record_response_widget.dart';

class LocalOpenEndedTypeWidget extends StatefulWidget {
  final int index;
  final List<Questionnaire> questionnaires;
  final Questionnaire questionnaire;
  final ValueChanged<Response> onSetResponse;
  final ValueChanged<int> onPressedPrev;
  final ValueChanged<int> onPressedNext;
  final List<String> addresses;

  const LocalOpenEndedTypeWidget({
    super.key,
    required this.index,
    required this.questionnaires,
    required this.questionnaire,
    required this.onSetResponse,
    required this.onPressedPrev,
    required this.onPressedNext,
    required this.addresses,
  });

  @override
  State<LocalOpenEndedTypeWidget> createState() => _LocalOpenEndedTypeWidgetState();
}

class _LocalOpenEndedTypeWidgetState extends State<LocalOpenEndedTypeWidget> {
  List<TextEditingController> fieldControllers = [];
  List<String> responses = [];
  List<String> fieldTexts = [];

  @override
  void initState() {
    super.initState();

    fieldControllers = widget.questionnaire.response?.responses.map((e)
      => TextEditingController(text: e)).toList() ?? [];
    responses = widget.questionnaire.response?.responses ?? [];
    fieldTexts = widget.questionnaire.labels.map((label) => label.name).toList();
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
          LocalGotoWidget(
            index: widget.index,
            questionnaires: widget.questionnaires,
            questionnaire: widget.questionnaire,
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
      widget.questionnaire.configs.enableAudioRecording ?? false;
    bool hasInput = widget.questionnaire.hasInput ?? false;

    if (enableAudioRecording && hasInput == false) {
      return Column(
        children: [
          const SizedBox(height: 5),
          LocalRecordResponseWidget(
            questionnaire: widget.questionnaire,
            questionnaires: widget.questionnaires,
            survey: widget.questionnaire.survey,
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
          isRequired: widget.questionnaire.configs.isRequired,
          question: widget.questionnaire.question,
        ),
        _recordingButton(),
        const SizedBox(height: 12),
      ],
    ));

    widget.questionnaire.labels.map(
      (label) => children.add(Column(children: [
        TextField(
          readOnly: widget.questionnaire.hasRecording == true,
          controller: fieldControllers.isNotEmpty
            ? fieldControllers[widget.questionnaire.labels.indexOf(label)]
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
            int index = widget.questionnaire.labels.indexOf(label);
            setState(() {
              responses.isNotEmpty
                ? responses[index] = value
                : responses = List.generate(
                  widget.questionnaire.labels.length, (i) =>
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
                fieldControllers = List.generate(
                  widget.questionnaire.labels.length, (j) =>
                    j == index ? TextEditingController(text: value) :
                    TextEditingController(text: ''));
              }
            });

            if (widget.questionnaire.response == null) {
              _setResponse();
            } else {
              widget.questionnaire.response?.responses = responses;
            }

            if (Functions.arrDoesNotOnlyContainsEmptyString(strArr: responses)) {
              widget.questionnaire.hasRecording = false;
              widget.questionnaire.hasInput = true;
            } else {
              widget.questionnaire.hasRecording = false;
              widget.questionnaire.hasInput = false;
            }
          },
        ),
        const SizedBox(height: 5),
      ])),
    ).toList();

    return children;
  }

  void _setResponse() {
    widget.onSetResponse(Response(
      surveyQuestion: widget.questionnaire.question,
      questionFieldTexts: fieldTexts,
      responses: responses,
      otherResponse: '',
    ));
  }
}
