import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/model/question.dart';
import 'database_helper.dart';

class QuestionHandle {
  Future<Question> getQuestionItemFromDatabase(int level) async {
    try {
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
    } catch (e) {
      if (e is DatabaseException) {
        await initQuestion();
        return getQuestionItemFromDatabase(level);
      }
      rethrow;
    }
  }

  Future<List<Question>> getQuestions() async {
    List<Question> q = [];
    for (int i = 1; i <= 15; i++) {
      q.add(await getQuestionItemFromDatabase(i));
    }
    return q;
  }

  Future<void> initQuestion() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'question.db');

      Reference ref = FirebaseStorage.instance.ref("Question.sqlite");
      await ref.writeToFile(File(path));
    } catch (e) {
      rethrow;
    }
  }
}
