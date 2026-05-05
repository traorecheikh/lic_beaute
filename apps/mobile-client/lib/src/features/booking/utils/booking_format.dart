String xof(int amount) {
  final thousands = amount ~/ 1000;
  final remainder = amount % 1000;
  return remainder == 0 ? '$thousands 000 XOF' : '$amount XOF';
}
