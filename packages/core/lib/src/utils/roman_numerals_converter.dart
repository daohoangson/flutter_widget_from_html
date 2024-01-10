const List<int> _arabianNumbers = [
  1000,
  900,
  500,
  400,
  100,
  90,
  50,
  40,
  10,
  9,
  5,
  4,
  1,
];

const List<String> _romanNumbers = [
  "M",
  "CM",
  "D",
  "CD",
  "C",
  "XC",
  "L",
  "XL",
  "X",
  "IX",
  "V",
  "IV",
  "I",
];

String? intToRomanNumerals(int input) {
  // This common rule only applies to number from range 1 to 3999
  if (input <= 0 || input > 3999) {
    return null;
  }

  var num = input;
  final romanNumberalsStrBuffer = StringBuffer();
  for (var a = 0; a < _arabianNumbers.length; a++) {
    final times = (num / _arabianNumbers[a]).truncate();
    // equals 1 only when arabianRomanNumbers[a] = num
    // executes n times where n is the number of times you have to add
    // the current roman number value to reach current num.
    romanNumberalsStrBuffer.write(_romanNumbers[a] * times);

    // subtract previous roman number value from num
    num -= times * _arabianNumbers[a];
  }

  return romanNumberalsStrBuffer.toString();
}
