import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:volume_controller/volume_controller.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/extension/integer_extension.dart';
import '../../../core/extension/string_extention.dart';
import '../../../data/model/question.dart';
import '../../../data/model/user.dart';
import '../../../network/exceptions/bad_request_exception.dart';
import '../../../core/services/question_box.dart';
import '../../../data/local_saver/question_level.dart';
import '../../../data/local_saver/sound_manager.dart';
import '../../../data/model/questions_model_hive.dart';
import '../repository/play_game_repository.dart';
import 'play_game_state.dart';

class PlayGameCubit extends Cubit<PlayGameState> {
  PlayGameCubit(this._playGameRepository, this.mc, this.isMute, this.user)
      : super(const PlayGameState());

  final PlayGameRepository _playGameRepository;
  final int mc;
  final bool isMute;
  final User user;

  void reset() {
    try {
      emit(state.copyWith(
        isChooseA: false,
        isTrueA: false,
        isChooseB: false,
        isTrueB: false,
        isChooseC: false,
        isTrueC: false,
        isChooseD: false,
        isTrueD: false,
        isHideA: false,
        isHideB: false,
        isHideC: false,
        isHideD: false,
        isShowGameResult: false,
        timeCounter: 60,
      ));
      cancelCountDown();
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  void setIsLoading(bool isLoading) =>
      emit(state.copyWith(isLoading: isLoading));

  void setIsAccessAnswer(bool isAccessAnswer) =>
      emit(state.copyWith(isAccessAnswer: isAccessAnswer));

  void chooseAnswer(String type, int rightAnswer) async {
    try {
      switch (type) {
        case 'A':
          await setItem('A', rightAnswer);
          break;
        case 'B':
          await setItem('B', rightAnswer);
          break;
        case 'C':
          await setItem('C', rightAnswer);
          break;
        case 'D':
          await setItem('D', rightAnswer);
          break;
      }
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      if (e is PlatformException) return;
      rethrow;
    }
  }

  Future<void> setItem(String type, int rightAnswer) async {
    cancelCountDown();
    if (state.isChooseA ||
        state.isChooseB ||
        state.isChooseC ||
        state.isChooseD ||
        state.isTrueA ||
        state.isTrueB ||
        state.isTrueC ||
        state.isTrueD) return;
    type == 'A'
        ? emit(state.copyWith(isChooseA: true))
        : type == 'B'
            ? emit(state.copyWith(isChooseB: true))
            : type == 'C'
                ? emit(state.copyWith(isChooseC: true))
                : emit(state.copyWith(isChooseD: true));
    await selectAnswer(type);
    if (checkAnswer(type)) {
      type == 'A'
          ? emit(state.copyWith(isTrueA: true))
          : type == 'B'
              ? emit(state.copyWith(isTrueB: true))
              : type == 'C'
                  ? emit(state.copyWith(isTrueC: true))
                  : emit(state.copyWith(isTrueD: true));
      await trueAnswer(type);
    } else {
      emit(state.copyWith(isFalse: true));
      await wrongAnswer(rightAnswer);
    }
    if (!state.isFalse &&
        (state.isTrueA || state.isTrueB || state.isTrueC || state.isTrueD)) {
      if (state.level < 15) {
        emit(state.copyWith(isShowGameResult: true));
        emit(state.copyWith(level: state.level + 1));
        saveQuestionLocal();
      } else {
        emit(state.copyWith(isWin: true));
      }
    }
    if (state.isShowGameResult) {
      await startQuestion(state.level);
      reset();
      countDown();
    }
  }

  bool checkAnswer(String type) {
    final typeToNumber = type.stringToAnswer();
    return typeToNumber == state.questions[state.level - 1].rightAnswer;
  }

  void setIsMute({bool? isMute}) async {
    if (isMute != null && isMute) {
      final player = state.player;
      if (player != null) {
        await player.setVolume(0);
        emit(state.copyWith(isMute: true));
        return;
      }
    }
    final player = state.player;
    if (player != null) {
      if (state.isMute) {
        await player.setVolume(1);
      } else {
        await player.setVolume(0);
      }
      emit(state.copyWith(isMute: !state.isMute));
    }
  }

  void countDown() {
    try {
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        try {
          if (state.timeCounter > 0) {
            emit(state.copyWith(timeCounter: state.timeCounter - 1));
          } else {
            timer.cancel();
          }
        } catch (e) {
          if (e is StateError) {
            cancelCountDown();
            stopAudio();
            return;
          }
          rethrow;
        }
      });
      emit(state.copyWith(timer: timer));
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  void cancelCountDown() {
    final timer = state.timer;
    if (timer != null) timer.cancel();
  }

  void delete2Answers(int right) async {
    try {
      List<int> list = [];
      for (int i = 1; i < 5; i++) {
        if (i == right) continue;
        list.add(i);
      }
      list.shuffle();
      final no1 = list[0].intToAnswer();
      final no2 = list[1].intToAnswer();
      emit(state.copyWith(isDelete2Answers: false));
      // cancelCountDown();
      await playAudio(SoundManager.delete2Answer(mc));
      hideAnswer(no1);
      hideAnswer(no2);
      // countDown();
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  void call(int right) async {
    try {
      emit(state.copyWith(isCall: false, isShowCall: false));
      // cancelCountDown();
      await playAudio(SoundManager.callHelp(mc));
      emit(state.copyWith(isShowCall: true));
      // countDown();
      trogiup(right);
    } catch (e) {
      rethrow;
    }
  }

  void hideAnswer(String type) {
    switch (type) {
      case 'A':
        emit(state.copyWith(isHideA: true));
        break;
      case 'B':
        emit(state.copyWith(isHideB: true));
        break;
      case 'C':
        emit(state.copyWith(isHideC: true));
        break;
      default:
        emit(state.copyWith(isHideD: true));
        break;
    }
  }

  void chart() async {
    try {
      emit(state.copyWith(isChart: false));
      // cancelCountDown();
      if (mc == 0) await playAudio(SoundManager.audianceHelp(mc));
      // countDown();
    } catch (e) {
      rethrow;
    }
  }

  void consultant() async {
    try {
      emit(state.copyWith(isConsultant: false));
      // cancelCountDown();
      await playAudio(SoundManager.consultantHelp(mc));
      // countDown();
    } catch (e) {
      rethrow;
    }
  }

  void openGameResult(bool isShowGameResult) {
    emit(state.copyWith(isShowGameResult: isShowGameResult));
  }

  void setIsFalse(bool isFalse) {
    emit(state.copyWith(isFalse: isFalse));
  }

  void saveQuestionLocal() async {
    try {
      clearDataLocal();
      QuestionBox.setQuestion(QuestionModelHive(
        currentLevel: state.level,
        questions: state.questions,
        isCall: state.isCall,
        isChart: state.isChart,
        isConsultant: state.isConsultant,
        isDelete2Answers: state.isDelete2Answers,
      ));
    } catch (e) {
      rethrow;
    }
  }

  void clearDataLocal() async {
    try {
      await QuestionBox.deleteAll();
    } catch (e) {
      rethrow;
    }
  }

  void updatePoint(String point) async {
    try {
      emit(state.copyWith(saveDone: false));
      final score = int.parse(point.replaceAll('.', ''));
      final x = User(
          name: state.user?.name ?? "",
          point: (state.user?.point ?? 0) + score,
          deviceId: user.deviceId,
          playDate: Timestamp.now());
      emit(state.copyWith(user: x));
      await _playGameRepository.updateUser(user: x);
      AnalyticsManager.postScore(score, state.level);
      emit(state.copyWith(saveDone: true));
    } catch (e) {
      if (e is StateError) return;
      rethrow;
    }
  }

  void init(QuestionModelHive? questionModelHive) async {
    try {
      setIsLoading(true);
      final player = AudioPlayer();
      final response = questionModelHive == null
          ? await _playGameRepository.getQuestions()
          : questionModelHive.questions; //QuestionLevel.questionPoints
      final questions = shuffleAnswer(response);
      emit(state.copyWith(
        questions: questions,
        player: player,
        isMute: isMute,
        user: user,
        chooseMC: mc,
      ));
      if (isMute) {
        final player = state.player;
        if (player != null) player.setVolume(0);
      }
      if (questionModelHive != null) {
        emit(state.copyWith(
          level: questionModelHive.currentLevel,
          isChart: questionModelHive.isChart,
          isCall: questionModelHive.isCall,
          isConsultant: questionModelHive.isConsultant,
          isDelete2Answers: questionModelHive.isDelete2Answers,
        ));
      }
      final duration = await getDuration(SoundManager.startGame(mc));
      emit(state.copyWith(startCounter: duration!.inSeconds + 1));
      Timer.periodic(const Duration(seconds: 1), (timer) {
        try {
          if (state.startCounter != null && state.startCounter! > 0) {
            emit(state.copyWith(startCounter: state.startCounter! - 1));
          } else {
            timer.cancel();
          }
        } catch (e) {
          timer.cancel();
          if (e is StateError) return;
          rethrow;
        }
      });
      await playAudio(SoundManager.startGame(mc));
      questionModelHive == null
          ? await startFirstQuestion()
          : await startQuestion(questionModelHive.currentLevel);
      saveQuestionLocal();
      setIsLoading(false);
      countDown();
    } catch (e) {
      if (e is BadRequestException) {
        setIsLoading(true);
        final player = AudioPlayer();
        final questions = QuestionLevel.questionPoints;
        emit(state.copyWith(questions: questions, player: player));

        await playAudio(SoundManager.startGame(mc));
        await startFirstQuestion();
        setIsLoading(false);
        countDown();
        return;
      }
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  void stopAudio() {
    try {
      final player = state.player;
      if (player != null) player.stop();
    } catch (e) {
      if (e is StateError) return;
      rethrow;
    }
  }

  Future<Duration?> getDuration(String name) async {
    try {
      final player = state.player;
      if (player != null) {
        setIsAccessAnswer(false);
        final assetSource =
            soundPath(state.isMute ? SoundManager.muteSound : name);
        final source = AssetSource(assetSource);
        await player.setSource(source);
        final duration = await player.getDuration();
        setIsAccessAnswer(true);
        return duration;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> playAudio(String name) async {
    try {
      final player = state.player;
      if (player != null) {
        setIsAccessAnswer(false);
        final systemSound = await VolumeController().getVolume();
        // debugPrint(systemSound.toString());
        final assetSource = soundPath(
            state.isMute || systemSound <= 0.3 ? SoundManager.muteSound : name);
        final source = AssetSource(assetSource);
        await player.play(source);
        await player.onPlayerComplete.first; //đảm bảo âm thanh đã chơi hết
        setIsAccessAnswer(true);
      }
    } catch (e) {
      if (e is StateError) {
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  Future<void> startQuestion(int question) async {
    try {
      await playAudio(SoundManager.startQuestion(mc, question));
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  Future<void> startFirstQuestion() async {
    try {
      await playAudio(SoundManager.startFirstQuestion(mc)[Random().nextInt(2)]);
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  Future<void> selectAnswer(String typre) async {
    try {
      await playAudio(
          SoundManager.selectAnswer(mc, typre)[Random().nextInt(3)]);
      await playAudio(
          SoundManager.selectAnswerAndReply(mc)[Random().nextInt(3)]);
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  Future<void> trueAnswer(String type) async {
    try {
      await playAudio(SoundManager.trueAnswer(mc, type)[Random().nextInt(5)]);
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  Future<void> wrongAnswer(int type) async {
    try {
      updatePoint(getQuestionByLevel(state.level - 1));
      clearDataLocal();
      type == 1
          ? emit(state.copyWith(isTrueA: true))
          : type == 2
              ? emit(state.copyWith(isTrueB: true))
              : type == 3
                  ? emit(state.copyWith(isTrueC: true))
                  : emit(state.copyWith(isTrueD: true));
      await playAudio(SoundManager.falseAnswer(mc, type));
      await chiatay();
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        // stopAudio();
        return;
      }
      rethrow;
    }
  }

  void trogiup(int type) async {
    try {
      await playAudio(SoundManager.trogiup(type)[Random().nextInt(4)]);
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  Future<void> chiatay() async {
    try {
      await playAudio(SoundManager.chiatay(mc)[Random().nextInt(2)]);
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  void outTime() async {
    try {
      updatePoint(getQuestionByLevel(state.level - 1));
      clearDataLocal();
      await playAudio(SoundManager.outTime());
      await chiatay();
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  void quesionStop() async {
    try {
      await playAudio(SoundManager.questionStop(mc));
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  void win() async {
    try {
      updatePoint(getQuestionByLevel(state.level));
      clearDataLocal();
      await playAudio(SoundManager.win(mc));
      await chiatay();
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        stopAudio();
        return;
      }
      rethrow;
    }
  }

  List<Question> shuffleAnswer(List<Question> question) {
    List<Question> questions = [];
    for (final i in question) {
      List<String> answers = List.from(i.answers ?? []);
      String rightAnswer = i.answers?[(i.rightAnswer ?? 1) - 1] ?? '';
      answers.shuffle();
      int dem = 0;
      for (final k in answers) {
        dem++;
        if (k.compareTo(rightAnswer) == 0) {
          break;
        }
      }
      questions.add(Question(
        level: i.level,
        answers: answers,
        question: i.question,
        rightAnswer: dem,
      ));
    }
    return questions;
  }

  void chooseDh(int chooDH) async {
    emit(state.copyWith(
      chooseDh: chooDH,
      loadingDh: true,
    ));
    await playAudio(SoundManager.dhSound);
    Future.delayed(const Duration(milliseconds: 2000), () async {
      emit(state.copyWith(loadingDh: false));
      await playAudio(SoundManager.dhSound);
    });
  }

  String soundPath(String name) => 'audios/$name.mp3';
}

String getQuestionByLevel(int level) {
  final list = List.from(QuestionLevel.questionPoints);
  for (final item in list) {
    if (item.level == level) return item.point;
  }
  return '0';
}
