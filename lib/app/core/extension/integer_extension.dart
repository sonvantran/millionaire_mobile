extension IntegerX on int {

  String intToAnswer() {
    switch (this) {
      case 1:
        return 'A';
      case 2:
        return 'B';
      case 3:
        return 'C';
      default:
        return 'D';
    }
  }

  String intToTimeType() {
    switch (this) {
      case 0:
        return 'day';
      case 1:
        return 'month';
      default:
        return 'year';
    }
  }
}
