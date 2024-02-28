import 'dart:io';
import 'dart:math';
import 'package:android_id/android_id.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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

  void initQuestion() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'question.db');

      if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound ||
          File(path).lengthSync() == 0) {
        Reference ref = FirebaseStorage.instance.ref("Question.sqlite");
        await ref.writeToFile(File(path));
      }
    } catch (e) {
      rethrow;
    }
  }

  void setIsMuteCheckAgain(bool isMuteCheckAgain) {
    emit(state.copyWith(isMuteCheckAgain: isMuteCheckAgain));
  }

  void setUser(User user) async {
    emit(state.copyWith(user: user));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("point", user.point);
    await prefs.setString("userName", user.name);
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
      initQuestion();
      final localUser = await getUserFromLocal();
      if (localUser != null) {
        final prefs = await SharedPreferences.getInstance();
        final validateName = await getBadWordsLocal();
        final mccc = prefs.getInt("mc");
        emit(state.copyWith(
          hasUser: true,
          user: localUser,
          chooseMC: mccc ?? 0,
          validateName: validateName,
        ));
        return;
      }
      final deviceId = await getId();
      final user = await _loginRepository.getUser(deviceId: deviceId ?? '');
      final prefs = await SharedPreferences.getInstance();
      final mccc = prefs.getInt("mc");
      emit(state.copyWith(
        hasUser: true,
        user: user,
        chooseMC: mccc ?? 0,
      ));
      await prefs.setInt("point", user.point);
      await prefs.setString("userName", user.name);
      final validateName = await getBadWordsLocal();
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
      if (e is StateError) return;
      rethrow;
    }
  }

  Future<User?> getUserFromLocal() async {
    final pre = await SharedPreferences.getInstance();
    final deviceId = await getId();
    final name = pre.getString("userName");
    final point = pre.getInt("point");
    if (name == null || point == null) return null;
    return User(name: name, point: point, deviceId: deviceId);
  }

  Future<String> getBadWordsLocal() async {
    final pre = await SharedPreferences.getInstance();
    final badWords = pre.getString("badWords");
    if (badWords == null) {
      final validateName = await _loginRepository.getBad();
      await pre.setString("badWords", validateName);
      return validateName;
    }
    return badWords;
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
      final pre = await SharedPreferences.getInstance();
      await pre.setString("userName", username);
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(hasUser: false, message: e.message));
        return;
      }
      if (e is StateError) return;
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
        final pre = await SharedPreferences.getInstance();
        await pre.remove("userName");
        await pre.remove("point");
      }
    } catch (e) {
      if (e is BadRequestException) {
        emit(state.copyWith(hasUser: true, message: e.message));
        return;
      }
      if (e is StateError) return;
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
        final pre = await SharedPreferences.getInstance();
        await pre.setInt("point", x.point);
        AnalyticsManager.postScore(score, null);
        clearQuestionLocal();
      }
    } catch (e) {
      if (e is StateError) return;
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
      if (player != null && player.state == PlayerState.playing) {
        await player.stop();
      }
      final player2 = state.player2;
      if (player2 != null && player2.state == PlayerState.playing) {
        await player2.stop();
      }
    } catch (e) {
      if (e is StateError) {
        return;
      }
      rethrow;
    }
  }

  void playBG() async {
    try {
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

Future<bool> checkHasQuestion() async {
  try {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'question.db');

    return !(FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound ||
        File(path).lengthSync() == 0);
  } catch (e) {
    rethrow;
  }
}
