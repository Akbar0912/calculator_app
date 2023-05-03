import 'dart:async';

import 'package:project_kalkulator/controller/inputDisplay.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  bool get isNumber => isNotEmpty && contains(RegExp(r'[0-9]'));//untuk pengecekan inputan number
}

class MyApps extends StatelessWidget {
  MyApps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<List<String>> listLayoutNumbers = [
      ['AC', 'C', '/'],
      ['7', '8', '9', 'x'],
      ['4', '5', '6', '+'],
      ['1', '2', '3', '-'],
      ['0', '.', '=']
    ];

    final Map<String, Color> charColors = {
      'AC': Colors.grey,
      'C': Colors.grey,
      '/': Colors.orange,
      'x': Colors.orange,
      '+': Colors.orange,
      '-': Colors.orange,
      '=': Colors.orange,
    };


    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  StreamBuilder<String>(
                    stream: inputDisplayController.stream,
                    builder: (context, snasphot) {
                      final str = snasphot.data ?? '0';
                      return Text(str,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                      );
                    }
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  StreamBuilder<String>(
                      stream: resulDisplayController.stream,
                    builder: (context, snasphot) {
                      final str = snasphot.data ?? '0';
                      return Text(str,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.grey,
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  for (final row in listLayoutNumbers)
                    Expanded(
                      child: Row(
                        children: [
                          for (final char in row)
                            Expanded(
                              flex: ['AC', '0'].contains(char) ? 2 : 1,
                              child: Material(
                                color: charColors.containsKey(char) ? charColors[char] : Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    if (char.isNumber) { //untuk number
                                      tempInputs.add(char);
                                      inputDisplayController.sink.add(tempInputs.join());
                                    } else if (char == '.') { //untuk koma

                                      int indexStartSub = tempInputs.lastIndexWhere((e) => ['/', 'x', '-', '+'].contains(e));
                                      int indexEndSub = tempInputs.length - 1;
                                      
                                      List<String> subTempInputs = List<String>.from(tempInputs);
                                      if (indexStartSub != -1) {
                                        subTempInputs = tempInputs.sublist(indexStartSub+1, indexEndSub+1);
                                      }

                                      if (!subTempInputs.contains('.')) {
                                        if (subTempInputs.isNotEmpty && subTempInputs.last.isNumber){
                                          tempInputs.add(char);
                                        }
                                      }
                                      inputDisplayController.sink.add(tempInputs.join());
                                    } else if (['/', 'x', '-', '+'].contains(char)){ //untuk operator
                                      if (tempInputs.isNotEmpty) {
                                        if(tempInputs.last.isNumber) {
                                          tempInputs.add(char);
                                        } else {
                                          tempInputs.removeLast();
                                          tempInputs.add(char);
                                        }
                                      }
                                      inputDisplayController.sink.add(tempInputs.join());
                                    }else if (char == 'AC') {
                                      clearAllinputs(); //menghapus semua inputan
                                    }else if (char == 'C') {
                                      delinputs();//menghapus inputan dari belakang
                                    }else if (char == '=') {
                                      calculateInputs();
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, //Perubahan: Mengatur bentuk tombol menjadi bulat
                                    ),
                                    child: Center(
                                      child: Text(
                                        char,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
