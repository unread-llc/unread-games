import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import '../logic/chess_controller.dart';
import '../state/chess_state.dart';
import 'package:chess/chess.dart' as chess;

class ChessScreen extends StatelessWidget {
  const ChessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChessController()..fetchPuzzle(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chess Puzzle')),
        body: Consumer<ChessController>(
          builder: (context, controller, child) {
            final state = controller.state;
            return state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      if (state.currentPuzzle != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Rating: ${state.currentPuzzle!.rating} | Themes: ${state.currentPuzzle!.themes.join(", ")}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: ChessBoard(
                            controller: ChessBoardController.fromGame(state.board ?? chess.Chess()),
                            boardColor: BoardColor.brown,
                            onMove: () {
                              controller.makeMove(state.board?.history.last?.toString() ?? '');
                            },
                          ),
                        ),
                        if (!state.isMoveCorrect)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Incorrect move! Try again.',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        if (state.isPuzzleSolved)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Puzzle Solved! Great job!',
                              style: TextStyle(color: Colors.green, fontSize: 16),
                            ),
                          ),
                        if (state.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: controller.showHint,
                                child: const Text('Hint'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: controller.resetPuzzle,
                                child: const Text('Reset'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: controller.fetchPuzzle,
                                child: const Text('Next Puzzle'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
          },
        ),
      ),
    );
  }
}