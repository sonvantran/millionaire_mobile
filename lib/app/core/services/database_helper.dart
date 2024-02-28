import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,
        'question.db'); // Thay 'your_database_name' bằng tên tệp SQLite của bạn

    // Kiểm tra xem tệp đã tồn tại trong thư mục local chưa
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Nếu chưa tồn tại, sao chép từ tệp asset vào thư mục local
      ByteData data = await rootBundle.load('assets/Question.sqlite');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path);
  }
}
