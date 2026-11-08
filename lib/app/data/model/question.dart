import 'package:hive/hive.dart';

part 'question.g.dart';

@HiveType(typeId: 1)
class Question {
  @HiveField(1)
  String? question;
  @HiveField(2)
  List<String>? answers;
  @HiveField(3)
  int? rightAnswer;
  @HiveField(4)
  int level;
  @HiveField(5)
  String? point;
  @HiveField(6)
  int? id;
  Question({
    this.question,
    this.answers,
    this.rightAnswer,
    required this.level,
    this.point,
    this.id,
  });

  factory Question.fromJson(Map<String, dynamic> map) {
    return Question(
      question: map['questions'] != null ? map['questions'] as String : null,
      answers: map['answer'] != null
          ? List<String>.from([
              map['answer']['a'] as String,
              map['answer']['b'] as String,
              map['answer']['c'] as String,
              map['answer']['d'] as String,
            ])
          : null,
      rightAnswer:
          map['truecase'] != null ? int.parse(map['truecase'] as String) : null,
      level: int.parse(map['level'] as String),
      point: map['point'] != null ? map['point'] as String : null,
    );
  }
}
