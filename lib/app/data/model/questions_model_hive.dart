// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'question.dart';

part 'questions_model_hive.g.dart';

@HiveType(typeId: 0)
class QuestionModelHive {
  @HiveField(1)
  List<Question> questions;

  @HiveField(2)
  int currentLevel;

  @HiveField(3)
  bool isChart;

  @HiveField(4)
  bool isConsultant;

  @HiveField(5)
  bool isCall;

  @HiveField(6)
  bool isDelete2Answers;

  QuestionModelHive({
    required this.questions,
    required this.currentLevel,
    required this.isChart,
    required this.isConsultant,
    required this.isCall,
    required this.isDelete2Answers,
  });
}
