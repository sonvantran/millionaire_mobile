import 'dart:io';
import 'dart:math';
import 'package:android_id/android_id.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/analytics/analytics_manager.dart';
import '../../../core/services/question_handle.dart';
import '../../../data/model/user.dart';
import '../../../network/exceptions/bad_request_exception.dart';
import '../../../core/services/question_box.dart';
import '../../../data/local_saver/sound_manager.dart';
import '../repository/login_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginRepository) : super(const LoginState());

  final LoginRepository _loginRepository;
  bool isBG = false;
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer player2 = AudioPlayer();

  void setIsMute(bool isMute) {
    emit(state.copyWith(isMute: isMute));
  }

  void initQuestion() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'question.db');
      if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound ||
          await File(path).length() == 0) {
        Reference ref = FirebaseStorage.instance.ref("Question.sqlite");
        await ref.writeToFile(File(path));
        emit(state.copyWith(message: "Tải xong câu hỏi"));
      }
    } catch (e) {
      rethrow;
    }
  }

  void callQuestionAgain() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'question.db');
      Reference ref = FirebaseStorage.instance.ref("Question.sqlite");
      await ref.writeToFile(File(path));
      emit(state.copyWith(message: "Tải xong câu hỏi"));
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
    try {
      final question = QuestionBox.getQuestions();
      emit(state.copyWith(hasDataLocal: question.isNotEmpty));
    } catch (e) {
      if (e is StateError) return;
      rethrow;
    }
  }

  void reviewApp() async {
    try {
      final pre = await SharedPreferences.getInstance();
      final isRating = pre.getBool("isRating") ?? false;
      if (!isRating) await pre.setBool("isRating", true);
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
      emit(state.copyWith(message: null));
      bool canLaunchEmail = await canLaunchUrl(emailLaunchUri);
      if (canLaunchEmail) {
        await launchUrl(emailLaunchUri);
      } else {
        emit(state.copyWith(
            message: 'Không tìm thấy ứng dụng email để gửi phản hồi'));
      }
    } catch (e) {
      rethrow;
    }
  }

  void login() async {
    try {
      await player.audioCache.clearAll();
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
      await prefs.setStringList('boughtItem', user.boughtItem ?? []);
      if (user.image != null) await prefs.setString("imageUser", user.image!);
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
    final image = pre.getString("imageUser");
    if (name == null || point == null || name.isEmpty) return null;
    return User(
      name: name,
      point: point,
      deviceId: deviceId,
      image: image,
      playDate: Timestamp.now(),
    );
  }

  Future<String> getBadWordsLocal() async {
    final pre = await SharedPreferences.getInstance();
    final badWords = pre.getString("badWords");
    if (badWords == null) {
      final badword = FirebaseRemoteConfig.instance.getString('badword');
      // final validateName = await _loginRepository.getBad();
      await pre.setString("badWords", badword);
      return badword;
    }
    return badWords;
  }

  void updateUser(String username) async {
    try {
      if (username.isEmpty) return;
      emit(state.copyWith(message: null));
      final userState = state.user;

      final deviceId = await getId();
      final x = User(
        name: username,
        point: userState?.point ?? 0,
        deviceId: deviceId,
        playDate: userState?.playDate ?? Timestamp.now(),
        image: userState?.image,
      );
      emit(state.copyWith(hasUser: true, user: x));
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
      final score = int.parse(point.replaceAll(RegExp(r'[^0-9]'), ''));
      final userState = state.user;
      if (userState != null) {
        final x = User(
          name: userState.name,
          point: (userState.point) + score,
          deviceId: userState.deviceId,
          playDate: Timestamp.now(),
          image: userState.image,
        );
        emit(state.copyWith(user: x));
        // await _loginRepository.updateUser(user: x);
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
      if (player.state == PlayerState.playing) {
        await player.stop();
      }
      if (player2.state == PlayerState.playing) {
        await player2.stop();
      }
    } catch (e) {
      if (e is StateError) {
        return;
      }
      if (e is Exception &&
          e.toString() == 'Exception: AudioPlayer has been disposed') {
        return;
      }
      rethrow;
    }
  }

  void playBG() async {
    try {
      if (!state.isMute) {
        await stopAudio();
        final source = AssetSource(soundPath(SoundManager.bgGame));
        await player.setReleaseMode(ReleaseMode.loop);
        await player.play(source);
        isBG = true;
      }
    } catch (e) {
      if (e is StateError) {
        stopAudio();
        return;
      }
      if (e is Exception &&
          e.toString() == 'Exception: AudioPlayer has been disposed') {
        return;
      }
      if (e is PlatformException) return;
      rethrow;
    }
  }

  void playAudio() async {
    try {
      if (!state.isMute) {
        await stopAudio();
        final source =
            AssetSource(soundPath(SoundManager.bg[Random().nextInt(3)]));
        await player.setReleaseMode(ReleaseMode.loop);
        await player.play(source);
        isBG = false;
      }
    } catch (e) {
      if (e is StateError) {
        stopAudio();
        return;
      }
      if (e is Exception &&
          e.toString() == 'Exception: AudioPlayer has been disposed') {
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
      if (!state.isMute) {
        final assetSource = soundPath(name);
        final source = AssetSource(assetSource);
        await player2.play(source);
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

  void clearQuestionLocal() async {
    await QuestionBox.deleteAll();
    setHasDataLocal();
  }

  String soundPath(String name) => 'audios/$name.mp3';

  @override
  Future<void> close() {
    player.dispose();
    player2.dispose();
    return super.close();
  }
}

Future<bool> checkHasQuestion() async {
  try {
    final x = await QuestionHandle().getQuestionItemFromDatabase(1);
    debugPrint(x.toString());
    return true;
  } catch (e) {
    return false;
  }
}
