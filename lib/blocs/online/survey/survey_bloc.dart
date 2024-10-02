import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bu_pulse/data/models/online/questions_model.dart';
import 'package:bu_pulse/data/models/online/surveys_model.dart';
import 'package:bu_pulse/data/resources/online/survey/survey_repo.dart';
import 'package:bu_pulse/helpers/functions.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SurveyRepository _surveyRepository = SurveyRepository();

  SurveyBloc() : super(SurveyInitialState()) {
    /// Getting a survey w/ questionnaires
    on<GetSurveyWithQuestionnairesEvent>((event, emit) async {
      try {
        emit(SurveyLoadingState());
        final surveyWithQuestionnaires = await _surveyRepository.getSurveyWithQuestionnaires(
          surveyId: event.surveyId,
          languageId: event.languageId,
        );
        emit(SurveyLoadedState(surveyWithQuestionnaires));
        Functions.audioRename(from: 'PENDING', to: 'DENY');
      } catch (error) {
        emit(SurveyErrorState(error.toString()));
      }
    });

    /// Submit a response from a survey
    on<SubmitSurveyResponseEvent>((event, emit) async {
      try {
        int numOfRequiredResponses = 0;
        List<Questions> questionnaires = event.survey.questionnaires ?? [];

        for (var question in questionnaires) {
          if (question.config.isRequired) {
            String otherAnswer = question.answer?.otherAnswer ?? '';
            List<String> answer = question.answer?.answers ?? [];
            String file = question.answer?.file ?? '';

            if ((answer.isNotEmpty && Functions.arrDoesNotOnlyContainsEmptyString(strArr: answer)) ||
              (otherAnswer.isNotEmpty) || (file.isNotEmpty)) {
              numOfRequiredResponses += 1;
            }
          }
        }

        if (event.survey.numOfRequired != numOfRequiredResponses) {
          emit(SurveyForReviewState());
        } else {
          emit(SurveyDoneState());
          await _surveyRepository.postSubmitSurveyResponse(survey: event.survey);
        }
      } catch (error) {
        emit(SurveyErrorState(error.toString()));
      }
    });
  }
}
