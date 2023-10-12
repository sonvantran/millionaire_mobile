// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questions_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionModelHiveAdapter extends TypeAdapter<QuestionModelHive> {
  @override
  final int typeId = 0;

  @override
  QuestionModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionModelHive(
      questions: (fields[1] as List).cast<Question>(),
      currentLevel: fields[2] as int,
      isChart: fields[3] as bool,
      isConsultant: fields[4] as bool,
      isCall: fields[5] as bool,
      isDelete2Answers: fields[6] as bool,
      mc: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModelHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.questions)
      ..writeByte(2)
      ..write(obj.currentLevel)
      ..writeByte(3)
      ..write(obj.isChart)
      ..writeByte(4)
      ..write(obj.isConsultant)
      ..writeByte(5)
      ..write(obj.isCall)
      ..writeByte(6)
      ..write(obj.isDelete2Answers)
      ..writeByte(7)
      ..write(obj.mc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
