import 'dart:async';
import 'package:project_kalkulator/MyApps.dart';

final StreamController<String> inputDisplayController = StreamController();
final StreamController<String> resulDisplayController = StreamController();

final List<String> tempInputs = []; //variabel penampung nilai sementara

void clearAllinputs() {
  if (tempInputs.isNotEmpty) {
    tempInputs.clear();
    inputDisplayController.sink.add(tempInputs.join());
  }
}

void delinputs() {
  if (tempInputs.isNotEmpty) {
    tempInputs.removeLast();
    if (tempInputs.isEmpty) {
      inputDisplayController.sink.add('0');
    }else {
      inputDisplayController.sink.add(tempInputs.join());
    }
  }
}

num calculate(String oper, num number1, num number2) {
  switch (oper) {
    case '+':
      return number1 + number2;
    case '-':
      return number1 - number2;
    case 'x':
      return number1 * number2;
    case '/':
     try {
       return number1 / number2;
     } catch (e) {
       return 0;
     }
    default:
      return 0;
  }
}

void calculateInputs() {
  if (tempInputs.isNotEmpty) {
    final tempNumbers = tempInputs.join().split(RegExp(r'[+-]|[/x]'));
    final tempOpers = tempInputs.join().split(RegExp(r'[0-9]|[.]'));
    tempOpers.removeWhere((e) => e.isEmpty);

    final mainNumbers = tempNumbers.map((e) => e.contains('.') ? double.parse(e) : int.parse(e)).toList();
    final mainOpers = List<String>.from(tempOpers);

    num result = 0;
    int countCalc = 0;

    do{
      final oper = mainOpers.removeAt(0);

      if (countCalc == 0) {
        final number1 = mainNumbers.removeAt(0);
        final number2 = mainNumbers.removeAt(0);

        result = calculate(oper, number1, number2);
        countCalc++;
      } else {
        final number = mainNumbers.removeAt(0);
        result = calculate(oper, result, number);
        countCalc++;
      }
    }while(mainOpers.isNotEmpty);

    resulDisplayController.sink.add(result.toString());
  }
}