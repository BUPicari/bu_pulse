import 'package:bu_pulse/data/models/online/surveys_model.dart';
import 'package:bu_pulse/data/resources/online/survey/survey_api_provider.dart';

class SurveyRepository {
  final _provider = SurveyApiProvider();

  /// Getting a survey w/ questionnaires
  Future<Surveys?> getSurveyWithQuestionnaires({
    required int surveyId,
    required int languageId,
  }) async {
    return _provider.getSurveyWithQuestionnaires(
      surveyId: surveyId,
      languageId: languageId,
    );
  }

  /// Submit survey responses
  Future<void> postSubmitSurveyResponse({ required Surveys survey }) async {
    _provider.postSubmitSurveyResponse(survey: survey);
  }
}
