import 'package:intl/intl.dart';
import '../values/regexp_constant.dart';

extension StringX on String {
  bool get isFormatDate {
    return RegexpConstants.date.hasMatch(this);
  }

  DateTime toFormatDate() {
    return DateFormat('dd/MM/yyyy').parse(this);
  }

  DateTime toFormatDate2() {
    return DateFormat('MM/dd/yyyy').parse(this);
  }

  int stringToAnswer() {
    switch (this) {
      case 'A':
        return 1;
      case 'B':
        return 2;
      case 'C':
        return 3;
      default:
        return 4;
    }
  }
}
