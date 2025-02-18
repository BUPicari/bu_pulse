import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:bu_pulse/data/models/online/answer_model.dart';
import 'package:bu_pulse/data/models/online/questions_model.dart';
import 'package:bu_pulse/helpers/functions.dart';

class SoundRecorderService {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;
  bool _isPlaybackReady = false;
  late Questions _question;

  bool get isRecordingAvailable => _isPlaybackReady && !isRecording;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init({ required Questions question }) async {
    _audioRecorder = FlutterSoundRecorder();
    _question = question;

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone Permission');
    }

    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  void dispose() async {
    if (!_isRecorderInitialised) return;

    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async {
    if (!_isRecorderInitialised) return;

    String timestamp = DateFormat.yMd().format(DateTime.now()).toString().replaceAll('/', '_');
    String appDirFolderPath = await Functions.getRecordingPath();
    String path = join(
      appDirFolderPath,
      'recording-$timestamp-question#${_question.id}-survey#${_question.surveyId}@PENDING.aac',
    );

    if (_question.answer == null) {
      _question.answer = Answer(
        surveyQuestion: _question.question,
        questionFieldTexts: List.generate(1, (i) => _question.question),
        answers: [],
        otherAnswer: '',
        file: path,
      );
    } else {
      _question.answer?.file = path;
    }
    _question.hasRecording = true;
    _question.hasInput = false;

    try {
      await _audioRecorder?.startRecorder(toFile: path);
      print('Recorder started successfully');
    } catch(e) {
      print('Error starting recorder: $e');
    }
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;

    await _audioRecorder!.stopRecorder();
    _isPlaybackReady = true;
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
