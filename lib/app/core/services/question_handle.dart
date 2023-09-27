import 'dart:math';

import 'package:sqflite/sqflite.dart';

import '../../data/model/question.dart';
import 'database_helper.dart';

class QuestionHandle {
  Future<Question> getQuestionItemFromDatabase(int level) async {
    final dbHelper = DatabaseHelper();
    final database = await dbHelper.db;

    final count = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM Question$level'));

    final int randomId = Random().nextInt(count ?? 0) + 1;

    final List<Map<String, dynamic>> randomQuestionData = await database
        .rawQuery('SELECT * FROM Question$level WHERE _id = $randomId');
    return Question(
      level: level,
      question: randomQuestionData.first["Question"] as String,
      answers: [
        randomQuestionData.first["CaseA"] as String,
        randomQuestionData.first["CaseB"] as String,
        randomQuestionData.first["CaseC"] as String,
        randomQuestionData.first["CaseD"] as String,
      ],
      rightAnswer: randomQuestionData.first["TrueCase"] as int,
    );
  }

  Future<List<Question>> getQuestions() async {
    List<Question> q = [];
    for (int i = 1; i <= 15; i++) {
      q.add(await getQuestionItemFromDatabase(i));
    }
    return q;
  }
}

void main(List<String> args) {
  // final a = QuestionHandle();
  // a.getDataFromDatabase();
}
