import 'dart:math';
import 'package:android_id/android_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:millionaire_mobile/app/data/model/user.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../network/exceptions/bad_request_exception.dart';
import '../../../core/services/question_box.dart';
import '../../../data/local_saver/sound_manager.dart';
import '../repository/login_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginRepository) : super(const LoginState());

  final LoginRepository _loginRepository;
  bool isBG = false;

  void setIsMute(bool isMute) {
    emit(state.copyWith(isMute: isMute));
  }

  void setIsMuteCheckAgain(bool isMuteCheckAgain) {
    emit(state.copyWith(isMuteCheckAgain: isMuteCheckAgain));
  }

  void setUser(User user) {
    emit(state.copyWith(user: user));
  }

  Future<void> setChooseMC(int chooseMC) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("mc", chooseMC);
    emit(state.copyWith(chooseMC: chooseMC));
    playAudioStartMc(chooseMC);
  }

  void setHasDataLocal() {
    final question = QuestionBox.getQuestions();
    emit(state.copyWith(hasDataLocal: question.isNotEmpty));
  }

  void reviewApp() async {
    try {
      final InAppReview inAppReview = InAppReview.instance;

      if (await inAppReview.isAvailable()) {
        inAppReview.openStoreListing();
      }
    } catch (e) {
      return;
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void feedBack() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: "thiepcong12@gmail.com",
      query: encodeQueryParameters(<String, String>{
        'subject': 'Phản hồi từ Game Ai Là Triệu Phú',
      }),
    );
    try {
      // if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
      // }
    } catch (e) {
      rethrow;
    }
  }

  void login() async {
    try {
      emit(state.copyWith(player: AudioPlayer(), player2: AudioPlayer()));
      playBG();
      setHasDataLocal();
      // if (accessToken != null) return;
      final deviceId = await getId();
      final user = await _loginRepository.getUser(deviceId: deviceId ?? '');
      final prefs = await SharedPreferences.getInstance();
      final mccc = prefs.getInt("mc");
      emit(state.copyWith(
        hasUser: true,
        user: user,
        chooseMC: mccc ?? 0,
      ));
      final validateName = await _loginRepository.getBad();
      emit(state.copyWith(validateName: validateName));
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(hasUser: false));
        return;
      }
      if (e is FirebaseException) {
        emit(state.copyWith(message: "Hệ thống đang gặp lỗi"));
        return;
      }
      rethrow;
    }
  }

  void updateUser(String username) async {
    try {
      emit(state.copyWith(message: null));
      final userState = state.user;

      final deviceId = await getId();
      final x = User(
          name: username,
          point: userState?.point ?? 0,
          deviceId: deviceId,
          playDate: userState?.playDate ?? Timestamp.now());
      emit(state.copyWith(hasUser: true, user: x));
      await _loginRepository.updateUser(user: x);
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(hasUser: false, message: e.message));
        return;
      }
      rethrow;
    }
  }

  void deleteUser() async {
    try {
      emit(state.copyWith(message: null));

      final deviceId = await getId();
      if (deviceId != null) {
        String message = await _loginRepository.deleteUser(deviceId: deviceId);
        emit(state.copyWith(hasUser: false, user: null, message: message));
      }
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(hasUser: true, message: e.message));
        return;
      }
      rethrow;
    }
  }

  void updatePoint(String point) async {
    try {
      final score = int.parse(point.replaceAll('.', ''));
      final userState = state.user;
      if (userState != null) {
        final x = User(
            name: userState.name,
            point: (userState.point) + score,
            deviceId: userState.deviceId,
            playDate: Timestamp.now());
        emit(state.copyWith(user: x));
        await _loginRepository.updateUser(user: x);
        AnalyticsManager.postScore(score, null);
        clearQuestionLocal();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getId() {
    const androidId = AndroidId();
    return androidId.getId();
  }

  Future<void> stopAudio() async {
    try {
      final player = state.player;
      if (player != null) await player.stop();
      final player2 = state.player2;
      if (player2 != null) await player2.stop();
    } catch (e) {
      if (e is StateError) {
        return;
      }
      rethrow;
    }
  }

  void playBG() async {
    try {
      // await player.play(AssetSource(soundPath('bg15')));
      final player = state.player;
      if (player != null && !state.isMute) {
        await stopAudio();
        final source = AssetSource(soundPath(SoundManager.bgGame));
        await player.setSource(source);
        await player.setReleaseMode(ReleaseMode.loop);
        await player.play(source);
        isBG = true;
      }
    } catch (e) {
      if (e is StateError) {
        stopAudio();
        return;
      }
      if (e is PlatformException) return;
      rethrow;
    }
  }

  void playAudio() async {
    try {
      // await player.play(AssetSource(soundPath('bg15')));
      final player = state.player;
      if (player != null && !state.isMute) {
        await stopAudio();
        final source =
            AssetSource(soundPath(SoundManager.bg[Random().nextInt(3)]));
        await player.setSource(source);
        await player.setReleaseMode(ReleaseMode.loop);
        await player.play(source);
        isBG = false;
      }
    } catch (e) {
      if (e is StateError) {
        stopAudio();
        return;
      }
      if (e is PlatformException) return;
      rethrow;
    }
  }

  void playAudioStartMc(int mc) async {
    await playAudioo(SoundManager.startGame(mc));
  }

  Future<void> playAudioo(String name) async {
    try {
      final player = state.player2;
      if (player != null && !state.isMute) {
        final assetSource = soundPath(name);
        final source = AssetSource(assetSource);
        await player.play(source);
        await player.onPlayerComplete.first;
      }
    } catch (e) {
      rethrow;
    }
  }

  void clearQuestionLocal() async {
    await QuestionBox.deleteAll();
    setHasDataLocal();
  }

  String soundPath(String name) => 'audios/$name.mp3';
}
