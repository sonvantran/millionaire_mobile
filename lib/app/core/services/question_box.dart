import 'package:hive/hive.dart';

import '../../data/model/questions_model_hive.dart';

class QuestionBox {
  static const String questionBox = 'question_box';

  static Future<void> openBox() async {
    await Hive.openBox<QuestionModelHive>(questionBox);
  }

  static Box<QuestionModelHive> getQuestionBox() {
    final box = Hive.box<QuestionModelHive>(questionBox);
    return box;
  }

  static void setQuestion(QuestionModelHive history) {
    final historyBox = getQuestionBox();
    historyBox.add(history);
  }

  static List<QuestionModelHive> getQuestions() {
    final questionBox = getQuestionBox();
    final historyList = questionBox.values.toList();
    return historyList;
  }

  static Future<int> deleteAll() {
    final questionBox = getQuestionBox();
    final result = questionBox.clear();
    return result;
  }
}
