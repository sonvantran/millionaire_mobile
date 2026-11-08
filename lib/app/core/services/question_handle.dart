import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/model/question.dart';
import 'database_helper.dart';

class QuestionHandle {
  static Map<String, dynamic>? _webData;

  // ---------- Lịch sử câu đã hỏi (theo từng mức) ----------
  static String _key(int level) => 'asked_questions_level_$level';

  Future<Set<int>> _getAsked(int level) async {
    final pref = await SharedPreferences.getInstance();
    return (pref.getStringList(_key(level)) ?? []).map(int.parse).toSet();
  }

  Future<void> _saveAsked(int level, Set<int> ids) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(
        _key(level), ids.map((e) => e.toString()).toList());
  }

  /// Gọi khi câu hỏi thật sự đã hiện ra cho người chơi
  Future<void> markAsked(int level, int id) async {
    final asked = await _getAsked(level);
    if (asked.add(id)) await _saveAsked(level, asked);
  }

  /// Gọi nếu muốn cho chơi lại từ đầu với toàn bộ câu hỏi
  Future<void> resetAskedHistory() async {
    final pref = await SharedPreferences.getInstance();
    for (int i = 1; i <= 15; i++) {
      await pref.remove(_key(i));
    }
  }

  // ---------- Web (JSON) ----------
  Future<Question> _getQuestionFromJson(int level) async {
    _webData ??= jsonDecode(
      await rootBundle.loadString('assets/db/questions.json'),
    ) as Map<String, dynamic>;
    final list = (_webData!['$level'] as List).cast<Map<String, dynamic>>();

    var pool = list;
    final asked = await _getAsked(level);
    final unasked =
        list.where((r) => !asked.contains(r['_id'] as int)).toList();
    if (unasked.isEmpty) {
      await _saveAsked(level, {}); // hết câu ở mức này -> reset riêng mức này
    } else {
      pool = unasked;
    }
    return _rowToQuestion(level, pool[Random().nextInt(pool.length)]);
  }

  // ---------- Mobile (SQLite) ----------
  Future<Question> getQuestionItemFromDatabase(int level) async {
    if (kIsWeb) return _getQuestionFromJson(level);
    try {
      final dbHelper = DatabaseHelper();
      final database = await dbHelper.db;

      final asked = await _getAsked(level);
      var rows = await database.rawQuery(
        'SELECT * FROM Question$level '
        '${asked.isNotEmpty ? 'WHERE _id NOT IN (${asked.join(',')}) ' : ''}'
        'ORDER BY RANDOM() LIMIT 1',
      );
      if (rows.isEmpty) {
        await _saveAsked(level, {}); // hết câu -> reset riêng mức này
        rows = await database
            .rawQuery('SELECT * FROM Question$level ORDER BY RANDOM() LIMIT 1');
      }
      return _rowToQuestion(level, rows.first);
    } catch (e) {
      if (e is DatabaseException) {
        await initQuestion();
        return getQuestionItemFromDatabase(level);
      }
      rethrow;
    }
  }

  Question _rowToQuestion(int level, Map<String, dynamic> row) => Question(
        level: level,
        id: row['_id'] as int,
        question: row['Question'] as String,
        answers: [
          row['CaseA'] as String,
          row['CaseB'] as String,
          row['CaseC'] as String,
          row['CaseD'] as String,
        ],
        rightAnswer: row['TrueCase'] as int,
      );

  Future<List<Question>> getQuestions() async {
    List<Question> q = [];
    for (int i = 1; i <= 15; i++) {
      q.add(await getQuestionItemFromDatabase(i));
    }
    return q;
  }

  static Future<void> copyBundledQuestions(String path) async {
    if (kIsWeb) return;
    final data = await rootBundle.load('assets/db/Question.sqlite');
    await File(path).writeAsBytes(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      flush: true,
    );
  }

  Future<void> initQuestion() async {
    if (kIsWeb) return;
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'question.db');
      await copyBundledQuestions(path);
    } catch (e) {
      rethrow;
    }
  }
}