import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/model/question.dart';
import '../../../data/model/user.dart';

part 'play_game_state.freezed.dart';

@freezed
class PlayGameState with _$PlayGameState {
  const PlayGameState._();

  const factory PlayGameState({
    @Default([]) List<Question> questions,
    @Default(true) bool isDelete2Answers,
    @Default(true) bool isCall,
    @Default(false) bool isShowCall,
    @Default(true) bool isConsultant,
    @Default(true) bool isChart,
    @Default(false) bool isFalse,
    @Default(false) bool isWin,
    @Default(false) bool isChooseA,
    @Default(false) bool isTrueA,
    @Default(false) bool isChooseB,
    @Default(false) bool isTrueB,
    @Default(false) bool isChooseC,
    @Default(false) bool isTrueC,
    @Default(false) bool isChooseD,
    @Default(false) bool isTrueD,
    @Default(false) bool isHideA,
    @Default(false) bool isHideB,
    @Default(false) bool isHideC,
    @Default(false) bool isHideD,
    @Default(false) bool isShowGameResult,
    @Default(false) bool isMute,
    @Default(false) bool isLoading,
    @Default(false) bool isAccessAnswer,
    @Default(0) int chooseMC,
    @Default(1) int level,
    @Default(60) int timeCounter,
    int? startCounter,
    Timer? timer,
    String? point,
    AudioPlayer? player,
    User? user,
    Error? error,
  }) = _PlayGameState;
}
