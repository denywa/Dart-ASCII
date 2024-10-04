import 'dart:async';
import 'dart:io';
import 'dart:math';

void animasiAsciiText() {
  List<String> text = [
    'HH   HH   BBBBBB    DDDDDD   ',
    'HH   HH   BB   BB   DD   DD  ',
    'HH   HH   BB   BB   DD   DD  ',
    'HHHHHHH   BBBBBB    DD   DD  ',
    'HH   HH   BB   BB   DD   DD  ',
    'HH   HH   BB   BB   DD   DD  ',
    'HH   HH   BBBBBB    DDDDDD   ',
    '',
    '    AA      NN   NN    OOOO   ',
    '   AAAA     NNN  NN   OO  OO  ',
    '  AA  AA    NN N NN   OO  OO  ',
    ' AA    AA   NN  NNN   OO  OO  ',
    'AAAAAAAAAA  NN   NN   OO  OO  ',
    'AA      AA  NN   NN   OO  OO  ',
    'AA      AA  NN   NN    OOOO   ',
  ];

  int terminalHeight = stdout.terminalLines;
  int terminalWidth = stdout.terminalColumns;

  int textHeight = text.length;
  int textWidth = text[0].length;

  int startRow = terminalHeight;

  Timer.periodic(Duration(milliseconds: 100), (timer) {
    if (startRow <= (terminalHeight - textHeight) ~/ 2) {
      timer.cancel();
      startColorAnimation(
          text, terminalHeight, terminalWidth, textHeight, textWidth);
    } else {
      stdout.write('\x1B[2J\x1B[0;0H'); // Clear screen
      for (int i = 0; i < textHeight; i++) {
        int row = startRow + i;
        if (row >= 0 && row < terminalHeight) {
          int col = (terminalWidth - textWidth) ~/ 2;
          stdout.write('\x1B[${row};${col}H${text[i]}');
        }
      }
      startRow--;
    }
  });
}

void startColorAnimation(List<String> text, int terminalHeight,
    int terminalWidth, int textHeight, int textWidth) {
  List<String> colors = [
    '\x1B[31m',
    '\x1B[32m',
    '\x1B[33m',
    '\x1B[34m',
    '\x1B[35m',
    '\x1B[36m'
  ];
  List<String> bgColors = [
    '\x1B[41m',
    '\x1B[42m',
    '\x1B[43m',
    '\x1B[44m',
    '\x1B[45m',
    '\x1B[46m'
  ];
  String reset = '\x1B[0m';

  Timer.periodic(Duration(milliseconds: 100), (timer) {
    String color = colors[Random().nextInt(colors.length)];
    String bgColor = bgColors[Random().nextInt(bgColors.length)];

    for (int phase = 0; phase < 3; phase++) {
      stdout.write('\x1B[2J\x1B[0;0H'); // Clear screen
      for (int i = 0; i < textHeight; i++) {
        int row = (terminalHeight - textHeight) ~/ 2 + i;
        int col = (terminalWidth - textWidth) ~/ 2;
        String line = text[i];
        for (int j = 0; j < line.length; j++) {
          if (line[j] != ' ') {
            if (phase == 0) {
              stdout.write('\x1B[${row};${col + j}H$color${line[j]}$reset');
            } else if (phase == 1) {
              stdout.write('\x1B[${row};${col + j}H$bgColor${line[j]}$reset');
            } else {
              stdout.write('\x1B[${row};${col + j}H${line[j]}');
            }
          } else {
            stdout.write('\x1B[${row};${col + j}H ');
          }
        }
      }
      addSparks(terminalHeight, terminalWidth, textHeight, textWidth);
      sleep(Duration(milliseconds: 100));
    }
  });
}

void addSparks(int terminalHeight, int terminalWidth, int textHeight, int textWidth) {
  List<String> sparkColors = [
    '\x1B[31m*\x1B[0m',
    '\x1B[32m*\x1B[0m',
    '\x1B[33m*\x1B[0m',
    '\x1B[34m*\x1B[0m',
    '\x1B[35m*\x1B[0m',
    '\x1B[36m*\x1B[0m'
  ];

  for (int i = 0; i < terminalHeight * terminalWidth / 100; i++) { // Further reduced the number of sparks
    int sparkX = Random().nextInt(terminalWidth);
    int sparkY = Random().nextInt(terminalHeight);

    String sparkColor = sparkColors[Random().nextInt(sparkColors.length)];
    stdout.write('\x1B[${sparkY};${sparkX}H$sparkColor');
  }
}
