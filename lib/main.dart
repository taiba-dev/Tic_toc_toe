import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minimumSize: Size(50, 50), // Adjusted size
            textStyle: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({Key? key}) : super(key: key);

  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  static const int rows = 3;
  static const int columns = 3;

  List<List<String?>> _board =
      List.generate(rows, (_) => List.filled(columns, null));
  String _currentPlayer = 'X';
  String? _winner;

  void _onTap(int row, int col) {
    if (_board[row][col] == null && _winner == null) {
      setState(() {
        _board[row][col] = _currentPlayer;
        if (_checkWinner(_currentPlayer)) {
          _winner = _currentPlayer;
        } else if (_board.expand((row) => row).every((cell) => cell != null)) {
          _winner = 'Tie';
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(String player) {
    for (int i = 0; i < rows; i++) {
      if (_board[i].every((cell) => cell == player) ||
          _board.every((row) => row[i] == player)) {
        return true;
      }
    }
    if (_board[0][0] == player &&
        _board[1][1] == player &&
        _board[2][2] == player) {
      return true;
    }
    if (_board[0][2] == player &&
        _board[1][1] == player &&
        _board[2][0] == player) {
      return true;
    }
    return false;
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(rows, (_) => List.filled(columns, null));
      _currentPlayer = 'X';
      _winner = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _winner == null
        ? Colors.black
        : _winner == 'Tie'
            ? Colors.orange
            : Colors.green;
    final statusText = _winner == null
        ? 'Player $_currentPlayer\'s Turn'
        : _winner == 'Tie'
            ? 'It\'s a Tie!'
            : 'Player $_winner Wins!';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        backgroundColor: Color.fromARGB(255, 233, 129, 207), // App bar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 138, 218, 169)!,
              Color.fromARGB(255, 219, 119, 211)!
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statusText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 550, // Adjusted width
              height: 495, // Adjusted height
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: rows * columns,
                padding: const EdgeInsets.all(55.0),
                itemBuilder: (context, index) {
                  final row = index ~/ columns;
                  final col = index % columns;
                  return ElevatedButton(
                    onPressed: () => _onTap(row, col),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _board[row][col] == 'X'
                          ? Colors.redAccent
                          : _board[row][col] == 'O'
                              ? Colors.blueAccent
                              : Colors.white,
                      foregroundColor:
                          _board[row][col] == 'X' || _board[row][col] == 'O'
                              ? Colors.white
                              : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(2),
                    ),
                    child: Text(
                      _board[row][col] ?? '',
                      style: TextStyle(
                        fontSize: 50, // Adjusted font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 2),
            ElevatedButton(
              onPressed: _resetGame,
              child: const Text('Restart Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent, // Restart button color
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
