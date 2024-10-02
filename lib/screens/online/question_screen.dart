import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import 'package:bu_pulse/data/models/online/answer_model.dart';
import 'package:bu_pulse/data/models/online/questions_model.dart';
import 'package:bu_pulse/data/models/online/surveys_model.dart';
import 'package:bu_pulse/helpers/functions.dart';
import 'package:bu_pulse/helpers/variables.dart';
import 'package:bu_pulse/screens/online/category_screen.dart';
import 'package:bu_pulse/widgets/loading_overlay_widget.dart';
import 'package:bu_pulse/widgets/online/question_numbers_widget.dart';
import 'package:bu_pulse/widgets/online/questions_widget.dart';

class QuestionScreen extends StatefulWidget {
  final Surveys survey;
  final List<String> addresses;
  final int? index;

  const QuestionScreen({
    super.key,
    required this.survey,
    required this.addresses,
    this.index,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  late PageController pageController;
  late Questions question;
  late ScrollController scrollController;
  late ListObserverController observerController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: widget.index ?? 0);
    question = widget.survey.questionnaires![widget.index ?? 0];
    scrollController = ScrollController(initialScrollOffset: 2.0);
    observerController = ListObserverController(controller: scrollController);

    setState(() {
      question.surveyId = widget.survey.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: buildAppBar(context: context),
        body: SafeArea(
          child: QuestionsWidget(
            survey: widget.survey,
            pageController: pageController,
            onChangedPage: (index) => goTo(index: index),
            onSetResponse: (response) => setResponse(response: response),
            onPressedPrev: (index) => setPrevQuestion(index: index),
            onPressedNext: (index) => setNextQuestion(index: index),
            addresses: widget.addresses,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar({ required context }) {
    return AppBar(
      foregroundColor: AppColor.subPrimary,
      title: Text(widget.survey.title),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColor.linearGradient,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back,
          color: AppColor.subPrimary,
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LoadingOverlayWidget(
            progressText: AppConfig.offlineModeText,
            child: CategoryScreen(addresses: widget.addresses),
          ),
        )),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: QuestionNumbersWidget(
            questions: widget.survey.questionnaires!,
            question: question,
            onClickedNumber: (index) => goTo(
              index: index,
              jump: true,
            ),
            scrollController: scrollController,
            observerController: observerController,
          ),
        ),
      ),
    );
  }

  void setResponse({ required Answer response }) {
    setState(() {
      question.answer = response;
    });
  }

  void setPrevQuestion({ required int index }) {
    goTo(
      index: index - 1,
      jump: true,
    );
  }

  void setNextQuestion({ required int index }) {
    goTo(
      index: index + 1,
      jump: true,
    );
  }

  void goTo({ required int index, bool jump = false }) {
    final indexPage = index;

    setState(() {
      question = widget.survey.questionnaires![indexPage];
      question.surveyId = widget.survey.id;
    });

    if (jump) {
      pageController.jumpToPage(indexPage);
      scrollTo(i: index);
    }
  }

  void scrollTo({ required int i }) {
    observerController.animateTo(
      index: i,
      duration: const Duration(seconds: 1),
      curve: Curves.ease,
    );
  }
}
