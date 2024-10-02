import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bu_pulse/blocs/online/survey/survey_bloc.dart';
import 'package:bu_pulse/data/models/online/surveys_model.dart';
import 'package:bu_pulse/helpers/functions.dart';
import 'package:bu_pulse/helpers/variables.dart';
import 'package:bu_pulse/screens/error_screen.dart';
import 'package:bu_pulse/screens/online/category_screen.dart';
import 'package:bu_pulse/screens/online/question_screen.dart';
import 'package:bu_pulse/widgets/loading_overlay_widget.dart';

class WaiverScreen extends StatelessWidget {
  final Surveys survey;
  final List<String> addresses;

  const WaiverScreen({
    super.key,
    required this.survey,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return BlocProvider(
      create: (context) => SurveyBloc()..add(GetSurveyWithQuestionnairesEvent(
        surveyId: survey.id,
        languageId: survey.languageId ?? 1,
      )),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<SurveyBloc, SurveyState>(
            builder: (context, state) {
              if (state is SurveyLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SurveyLoadedState) {
                if (state.surveyWithQuestionnaires?.title == "none") {
                  return const ErrorScreen(
                    error: "Unable to Take the Survey!",
                  );
                }
                return _buildContent(context: context, surveyWithQuestionnaires: state.surveyWithQuestionnaires);
              }
              if (state is SurveyErrorState) {
                return ErrorScreen(error: state.error);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent({ context, Surveys? surveyWithQuestionnaires }) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColor.linearGradient,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 50),
                  SizedBox(
                    child: SvgPicture.asset(
                      'assets/images/survey-waiver.svg',
                      semanticsLabel: 'Survey Waiver',
                      height: 260,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    child: Text(
                      'WAIVER',
                      style: TextStyle(
                        fontSize: 30,
                        color: AppColor.subPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    child: Text(
                      surveyWithQuestionnaires?.waiver ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColor.subPrimary,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 30),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoadingOverlayWidget(
                            progressText: AppConfig.offlineModeText,
                            child: CategoryScreen(addresses: addresses),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.subPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(33),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Back',
                          style: TextStyle(
                            color: AppColor.subSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionScreen(
                            survey: surveyWithQuestionnaires!,
                            addresses: addresses,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.subPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(33),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Proceed',
                          style: TextStyle(
                            color: AppColor.subSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
