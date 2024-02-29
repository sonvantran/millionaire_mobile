import 'package:audioplayers/audioplayers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/model/user.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default(false) bool isMute,
    @Default(false) bool isMuteCheckAgain,
    @Default(true) bool hasUser,
    @Default(false) bool hasDataLocal,
    String? validateName,
    User? user,
    @Default(0) int chooseMC,
    AudioPlayer? player,
    AudioPlayer? player2,
    String? message,
    Error? error,
  }) = _LoginState;
}
