import 'package:millionaire_mobile/app/core/extension/string_extention.dart';

class SoundManager {
  static String bgGame = 'bg';
  static List<String> bg = [
    'bgmusic_level1',
    'bgmusic_level2',
    'bgmusic_level3',
  ];

  static List<String> selectAnswer(int i, String type) {
    int right = type.stringToAnswer();
    return [
      '${intToMc(i)}/ans_${right}_1',
      '${intToMc(i)}/ans_${right}_2',
      '${intToMc(i)}/ans_${right}_3',
    ];
  }

  static List<String> selectAnswerAndReply(
    int i,
  ) =>
      [
        '${intToMc(i)}/answer_now1',
        '${intToMc(i)}/answer_now2',
        '${intToMc(i)}/answer_now3',
      ];

  static String startGame2(int i) => '${intToMc(i)}/gofind_quick';

  static String startGame(int i) => '${intToMc(i)}/batdauvaogame';

  static String delete2Answer(int i) => '${intToMc(i)}/remove50';

  static String callHelp(int i) => '${intToMc(i)}/conect_call';

  static String consultantHelp(int i) => '${intToMc(i)}/sound_trogiup_tuvan';

  static String audianceHelp(int i) => '${intToMc(i)}/help_ask';

  static String congraStage(int i, int stage) =>
      '${intToMc(i)}/congrats_stage$stage';

  static String startQuestion(int i, int level) =>
      '${intToMc(i)}/start_cau$level';

  static String ruleGame(int i) => '${intToMc(i)}/rule';

  static List<String> startFirstQuestion(int i) =>
      ['${intToMc(i)}/start_cau1', '${intToMc(i)}/start_cau_1b'];

  static List<String> trueAnswer(int i, String type) {
    int right = type.stringToAnswer();
    return [
      '${intToMc(i)}/true_${right}_1',
      '${intToMc(i)}/true_${right}_2',
      '${intToMc(i)}/true_1',
      '${intToMc(i)}/true_2',
      '${intToMc(i)}/true_3',
    ];
  }

  static String falseAnswer(int i, int rightAnswer) {
    return '${intToMc(i)}/lose_$rightAnswer';
  }

  static String questionStop(int i) => '${intToMc(i)}/question_stop';

  static String outTime() => 'out_of_time';

  static List<String> trogiup(int answer) {
    return [
      'trogiup_1_$answer',
      'trogiup_2_$answer',
      'trogiup_3_$answer',
      'trogiup_4_$answer',
    ];
  }

  static List<String> chiatay(int i) {
    return [
      '${intToMc(i)}/sound_ket_thuc',
      '${intToMc(i)}/sound_chiatay',
    ];
  }

  static String win(int i) {
    String mc = intToMc(i);
    if (i > 1) return '$mc/congrats_stage3';
    return '$mc/pass_15';
  }

  static String muteSound = 'tinh';

  static String dhSound = 'ping';

  static String intToMc(int i) {
    switch (i) {
      case 0:
        return 'lvs';
      case 1:
        return 'pd';
      default:
        return 'gsx';
    }
  }
}
