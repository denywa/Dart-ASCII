import 'dart:io';
import 'dart:math';
import 'ascii_ANO.dart'; 

// Warna menggunakan kode ANSI
const String reset = '\x1B[0m';
const String red = '\x1B[31m';
const String green = '\x1B[32m';
const String yellow = '\x1B[33m';
const String blue = '\x1B[34m';
const String magenta = '\x1B[35m';
const String cyan = '\x1B[36m';
const List<String> colors = [red, green, yellow, blue, magenta, cyan];

// Warna background menggunakan kode ANSI
const String bgRed = '\x1B[41m';
const String bgGreen = '\x1B[42m';
const String bgYellow = '\x1B[43m';
const String bgBlue = '\x1B[44m';
const String bgMagenta = '\x1B[45m';
const String bgCyan = '\x1B[46m';
const Map<String, String> colorToBackground = {
  red: bgRed,
  green: bgGreen,
  yellow: bgYellow,
  blue: bgBlue,
  magenta: bgMagenta,
  cyan: bgCyan,
};

void main() async {
  stdout.write('Masukkan jumlah kembang api: ');
  int jumlahKembangApi = int.parse(stdin.readLineSync()!);

  for (int i = 0; i < jumlahKembangApi; i++) {
    if (i == 0) {
      await animasiKembangApiTengah(0.6); // 60% dari tinggi layar
    } else {
      await animasiKembangApiRandom(0.7); // 70% dari tinggi layar
    }
    await Future.delayed(Duration(milliseconds: 500));
    clearScreen();
  }

  animasiAsciiText();
}

Future<void> animasiKembangApiTengah(double maxHeightFactor) async {
  int tinggiTerminal = stdout.terminalLines;
  int lebarTerminal = stdout.terminalColumns;
  int maxHeight = (tinggiTerminal * maxHeightFactor).floor();

  for (int i = tinggiTerminal - 1; i >= tinggiTerminal - maxHeight; i--) {
    for (int j = 0; j < tinggiTerminal; j++) {
      if (j == i) {
        print(' ' * (lebarTerminal ~/ 2) + '†');
      } else {
        print('');
      }
    }
    await Future.delayed(Duration(milliseconds: 25));
  }

  String randomColor = colors[Random().nextInt(colors.length)];
  await animasiLedakanKembangApi(
      randomColor, lebarTerminal ~/ 2, tinggiTerminal - maxHeight);
}

Future<void> animasiKembangApiRandom(double maxHeightFactor) async {
  int tinggiTerminal = stdout.terminalLines;
  int lebarTerminal = stdout.terminalColumns;
  int maxHeight = (tinggiTerminal * maxHeightFactor).floor();
  int posisiX = Random().nextInt(lebarTerminal - 30) + 15;

  for (int i = tinggiTerminal - 1; i >= tinggiTerminal - maxHeight; i--) {
    for (int j = 0; j < tinggiTerminal; j++) {
      if (j == i) {
        print(' ' * posisiX + '†');
      } else {
        print('');
      }
    }
    await Future.delayed(Duration(milliseconds: 25));
  }

  String randomColor = colors[Random().nextInt(colors.length)];
  await animasiLedakanKembangApi(
      randomColor, posisiX, tinggiTerminal - maxHeight);
}

Future<void> animasiLedakanKembangApi(String color, int x, int y) async {
  List<List<Point<int>>> tahapanLedakan = generateLedakanPattern();
  List<List<Point<int>>> tahapanLedakanDalam = generateLedakanDalamPattern();

  String bgColor = colorToBackground[color]!;

  for (int i = 0; i < tahapanLedakan.length; i++) {
    tampilkanLedakan(color, bgColor, x, y, tahapanLedakan[i]);
    await Future.delayed(Duration(milliseconds: 50));

    // Mulai menampilkan ledakan dalam setelah beberapa tahap
    if (i >= tahapanLedakan.length ~/ 2 && i < tahapanLedakanDalam.length) {
      tampilkanLedakan(color, bgColor, x, y,
          tahapanLedakanDalam[i - tahapanLedakan.length ~/ 2]);
    }
    await Future.delayed(Duration(milliseconds: 50));
  }
}

List<List<Point<int>>> generateLedakanPattern() {
  List<List<Point<int>>> tahapanLedakan = [];
  int maxRadius = 15;
  int numSteps = 10;

  for (int step = 1; step <= numSteps; step++) {
    List<Point<int>> points = [];
    int radius = (maxRadius * step / numSteps).round();

    for (int angle = 0; angle < 360; angle += 10) {
      double radian = angle * pi / 180;
      int px = (radius * cos(radian)).round();
      int py = (radius * sin(radian) / 2).round(); 
      points.add(Point(px, py));

   
      if (Random().nextBool()) {
        int rx = px + Random().nextInt(3) - 1;
        int ry = py + Random().nextInt(3) - 1;
        points.add(Point(rx, ry));
      }
    }
    tahapanLedakan.add(points);
  }

  return tahapanLedakan;
}

List<List<Point<int>>> generateLedakanDalamPattern() {
  List<List<Point<int>>> tahapanLedakanDalam = [];
  int maxRadius = 10;
  int numSteps = 5;

  for (int step = 1; step <= numSteps; step++) {
    List<Point<int>> points = [];
    int radius = (maxRadius * step / numSteps).round();

    for (int angle = 0; angle < 360; angle += 15) {
      double radian = angle * pi / 180;
      for (int r = 0; r <= radius; r += 2) {
        int px = (r * cos(radian)).round();
        int py = (r * sin(radian) / 2).round(); 
        points.add(Point(px, py));

        if (Random().nextBool()) {
          int rx = px + Random().nextInt(3) - 1;
          int ry = py + Random().nextInt(3) - 1;
          points.add(Point(rx, ry));
        }
      }
    }
    tahapanLedakanDalam.add(points);
  }

  return tahapanLedakanDalam;
}

void tampilkanLedakan(String color, String bgColor, int centerX, int centerY,
    List<Point<int>> ledakan) {
  int tinggiTerminal = stdout.terminalLines;
  int lebarTerminal = stdout.terminalColumns;
  List<List<String>> screen =
      List.generate(tinggiTerminal, (_) => List.filled(lebarTerminal, ' '));

  // Render firework particles
  for (Point<int> point in ledakan) {
    int x = centerX + point.x;
    int y = centerY + point.y;
    if (x >= 0 && x < lebarTerminal && y >= 0 && y < tinggiTerminal) {
      screen[y][x] = '*';
    }
  }

  // Render screen with dynamic background
  StringBuffer buffer = StringBuffer();
  for (int y = 0; y < tinggiTerminal; y++) {
    String line = '';
    bool inFirework = false;
    for (int x = 0; x < lebarTerminal; x++) {
      if (screen[y][x] == '*') {
        line += color + '*' + reset;
        inFirework = true;
      } else if (inFirework && x > 0 && screen[y][x - 1] == '*') {
        line += reset + ' ';
        inFirework = false;
      } else {
        line += inFirework ? reset + ' ' : bgColor + ' ' + reset;
      }
    }
    buffer.writeln(line);
  }
  stdout.write(buffer.toString());
}

void clearScreen() {
  if (Platform.isWindows) {
    print(Process.runSync('cls', [], runInShell: true).stdout);
  } else {
    print(Process.runSync('clear', [], runInShell: true).stdout);
  }
}
