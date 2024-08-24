import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_ads/sky_ads.dart';
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
  final User? user;
  final AudioPlayer player = AudioPlayer();

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
        startCounter: null,
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
      rightAnswer == 1
          ? emit(state.copyWith(isTrueA: true))
          : rightAnswer == 2
              ? emit(state.copyWith(isTrueB: true))
              : rightAnswer == 3
                  ? emit(state.copyWith(isTrueC: true))
                  : emit(state.copyWith(isTrueD: true));
      await playAudio(SoundManager.falseAnswer(mc, rightAnswer));
      await wrongAnswer();
    }
    if (!state.isFalse &&
        (state.isTrueA || state.isTrueB || state.isTrueC || state.isTrueD) &&
        !state.isShowWrongAds) {
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
    try {
      if (isMute != null && isMute) {
        await player.setVolume(0);
        emit(state.copyWith(isMute: true));
        return;
      }
      if (state.isMute) {
        await player.setVolume(1);
      } else {
        await player.setVolume(0);
      }
      emit(state.copyWith(isMute: !state.isMute));
    } catch (e) {
      if (e is StateError) return;
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
          isDelete2Answers: state.isDelete2Answers));
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
      cancelCountDown();
      emit(state.copyWith(saveDone: false));
      final score = int.parse(point.replaceAll(RegExp(r'[^0-9]'), ''));
      if (user == null) {
        emit(state.copyWith(saveDone: true));
        return;
      }
      final x = User(
        name: state.user?.name ?? "",
        point: (state.user?.point ?? 0) + score,
        deviceId: user!.deviceId,
        playDate: Timestamp.now(),
        image: state.user?.image,
      );
      emit(state.copyWith(user: x));
      if (SkyAds.instance.isAdDisable) {
        emit(state.copyWith(saveDone: true));
        return;
      }
      await _playGameRepository.updateUser(user: x);
      AnalyticsManager.postScore(score, state.level);
      emit(state.copyWith(saveDone: true));
    } catch (e) {
      if (e is StateError) return;
      if (e is BadRequestException) {
        emit(state.copyWith(saveDone: true));
        return;
      }
      emit(state.copyWith(saveDone: true));
      rethrow;
    }
  }

  void init(QuestionModelHive? questionModelHive) async {
    try {
      setIsLoading(true);
      final response = questionModelHive == null
          ? await _playGameRepository.getQuestions()
          : questionModelHive.questions;
      final questions = shuffleAnswer(response);
      emit(state.copyWith(
        questions: questions,
        isMute: isMute,
        user: user,
        chooseMC: mc,
      ));
      if (isMute) {
        player.setVolume(0);
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
      await ruleGame(questionModelHive);
      return;
    } catch (e) {
      if (e is BadRequestException) {
        setIsLoading(true);
        final questions = QuestionLevel.questionPoints(mc);
        emit(state.copyWith(questions: questions));

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

  Future<void> init2(QuestionModelHive? questionModelHive) async {
    try {
      final duration = await getDuration(SoundManager.startGame2(mc));
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
      await playAudio(SoundManager.startGame2(mc));
      questionModelHive == null
          ? await startFirstQuestion()
          : await startQuestion(questionModelHive.currentLevel);
      saveQuestionLocal();
      setIsLoading(false);
      countDown();
    } catch (e) {
      if (e is BadRequestException) {
        setIsLoading(true);
        final questions = QuestionLevel.questionPoints(mc);
        emit(state.copyWith(questions: questions));

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
      player.stop();
    } catch (e) {
      if (e is StateError) return;
      rethrow;
    }
  }

  Future<Duration?> getDuration(String name) async {
    try {
      setIsAccessAnswer(false);
      final assetSource =
          soundPath(state.isMute ? SoundManager.muteSound : name);
      final source = AssetSource(assetSource);
      // final duration = await player.setAsset(assetSource);
      await player.setSource(source);
      final duration = await player.getDuration();
      setIsAccessAnswer(true);
      return duration;
    } catch (e) {
      rethrow;
    }
  }

  void skipAudio() {
    playAudio(SoundManager.dhSound);
  }

  Future<void> playAudio(String name) async {
    try {
      setIsAccessAnswer(false);
      final systemSound = await VolumeController().getVolume();
      final assetSource = soundPath(
          state.isMute || systemSound <= 0.06 ? SoundManager.muteSound : name);
      final source = AssetSource(assetSource);
      await player.play(source);
      await player.onPlayerComplete.first;
      // await player.playerStateStream.firstWhere(
      //     (state) => state.processingState == ProcessingState.completed);
      setIsAccessAnswer(true);
    } catch (e) {
      if (e is StateError) {
        stopAudio();
        return;
      }
      if (e is PlatformException) return;
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
      clearDataLocal();
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

  bool firsrWrong = false;
  bool isCallOnce = false;

  Future<void> wrongAnswer() async {
    try {
      clearDataLocal();
      if (!firsrWrong && !SkyAds.instance.isAdDisable) {
        firsrWrong = true;
        emit(
          state.copyWith(
              isShowWrongAds: true,
              startCounter:
                  FirebaseRemoteConfig.instance.getInt("countDownAds")),
        );
        final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          try {
            if (state.startCounter != null && state.startCounter! > 0) {
              emit(state.copyWith(startCounter: state.startCounter! - 1));
            } else {
              wrongAnswer();
              timer.cancel();
            }
          } catch (e) {
            timer.cancel();
            if (e is StateError) return;
            rethrow;
          }
        });
        emit(state.copyWith(timer: timer));
        return;
      }
      if (isCallOnce) return;
      isCallOnce = true;
      emit(state.copyWith(isFalse: true));
      int level = 0;
      if (state.level >= 0 && state.level <= 5) {
        level = state.level - 1;
      } else if (state.level >= 6 && state.level <= 10) {
        level = 5;
      } else {
        level = 10;
      }
      updatePoint(getQuestionByLevel(level));
    } catch (e) {
      if (e is StateError) {
        cancelCountDown();
        // stopAudio();
        return;
      }
      rethrow;
    }
  }

  bool isCallOnce2 = false;
  void playAgainAds() async {
    try {
      if (isCallOnce2) return;
      isCallOnce2 = true;
      emit(state.copyWith(isShowWrongAds: false));
      final response = await _playGameRepository.getQuestions();
      final questions = shuffleAnswer(response);
      emit(state.copyWith(questions: questions));
      saveQuestionLocal();
      reset();
      countDown();
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

  void outTime() async {
    try {
      clearDataLocal();
      int level = 0;
      if (state.level >= 0 && state.level <= 5) {
        level = state.level;
      } else if (state.level >= 6 && state.level <= 10) {
        level = 5;
      } else {
        level = 10;
      }
      updatePoint(getQuestionByLevel(level));
      await playAudio(SoundManager.outTime());
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

  void setShowInstruction(bool isShowInstruction) {
    emit(state.copyWith(isShowInstruction: isShowInstruction));
  }

  Future<void> ruleGame(QuestionModelHive? questionModelHive) async {
    try {
      final pref = await SharedPreferences.getInstance();
      final isFirstPlay = pref.getBool("isFirstPlay") ?? true;
      final systemSound = await VolumeController().getVolume();
      if (!isFirstPlay || state.isMute || systemSound <= 0.1) {
        init2(questionModelHive);
        return;
      }
      pref.setBool("isFirstPlay", false);
      emit(state.copyWith(isShowGameResult: true));
      int x = state.level;
      playAudio(SoundManager.ruleGame(mc));
      Future.delayed(const Duration(seconds: 5)).then((value) {
        try {
          emit(
              state.copyWith(isShowGameResult: false, isShowInstruction: true));
        } catch (e) {
          if (e is StateError) return;
        }
      });
      await Future.delayed(const Duration(seconds: 4));
      emit(state.copyWith(level: 5));
      await Future.delayed(const Duration(milliseconds: 400));
      emit(state.copyWith(level: 10));
      await Future.delayed(const Duration(milliseconds: 400));
      emit(state.copyWith(level: 15));
      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(level: x));
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

  void dispose() {
    player.stop();
    player.dispose();

    state.timer?.cancel();
  }

  String getQuestionByLevel(int level) {
    final list = List.from(QuestionLevel.questionPoints(mc));
    for (final item in list) {
      if (item.level == level) return item.point;
    }
    return '0';
  }
}
