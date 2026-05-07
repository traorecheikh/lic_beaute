import 'package:intl/intl.dart';

final NumberFormat _xofFormatter = NumberFormat.decimalPattern('fr_FR');

String xof(int amount) => '${_xofFormatter.format(amount)} XOF';
