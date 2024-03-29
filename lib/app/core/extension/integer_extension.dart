extension IntegerX on int {
  String toPointDisplay() {
    final value = this;
    if (value < 1000000000) {
      return '${(value / 1000000).toStringAsFixed(1)} Tr';
    }
    return '${formatNumber(value ~/ 1000000)} Tr';
  }

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

  String intToNdh() {
    switch (this) {
      case 1:
        return "Doraemon";
      case 2:
        return "Mickey Mouse";
      case 3:
        return "Bill Gates";
      case 4:
        return "Homer Simpson";
      case 5:
        return "Stephen Hawking";
      default:
        return "Elon Musk";
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

  String formatNumber(int i) {
    String formatted = "";
    String input = i.toString();
    int length = input.length;

    for (int i = length - 1, count = 0; i >= 0; i--, count++) {
      if (count != 0 && count % 3 == 0) {
        formatted = ',$formatted';
      }
      formatted = input[i] + formatted;
    }

    return formatted;
  }
}
