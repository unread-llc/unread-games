import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chess/chess.dart' as chess;
import 'package:flutter/foundation.dart';
import '../state/chess_state.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class ChessController extends ChangeNotifier {
  ChessState _state = const ChessState();
  ChessState get state => _state;

  Future<void> fetchPuzzle() async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            'https://chess-puzzles.p.rapidapi.com/?themes=%5B%22middlegame%22%2C%22advantage%22%5D&rating=500&themesType=ALL&playerMoves=1&count=1'),
        headers: {
          'x-rapidapi-host': 'chess-puzzles.p.rapidapi.com',
          'x-rapidapi-key': '49ecac8639mshb282fd6568e0536p1a2db4jsn1ef78a9b7e5f',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['puzzles'][0];
        print('Puzzle data: $data');
        final puzzle = ChessPuzzle(
          puzzleId: data['puzzleid'],
          fen: data['fen'],
          rating: data['rating'],
          moves: List<String>.from(data['moves']),
          themes: List<String>.from(data['themes']),
        );
        final board = chess.Chess.fromFEN(puzzle.fen);
        _state = _state.copyWith(
          currentPuzzle: puzzle,
          board: board,
          currentMoveIndex: 0,
          isPuzzleSolved: false,
          isMoveCorrect: true,
          isLoading: false,
        );
      } else {
        _state = _state.copyWith(
          errorMessage: 'Failed to load puzzle: ${response.statusCode}',
          isLoading: false,
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        errorMessage: 'Error: $e',
        isLoading: false,
      );
    }
    notifyListeners();
  }

  void makeMove(String move) {
    if (_state.currentPuzzle == null || _state.board == null || _state.isPuzzleSolved) return;

    final board = chess.Chess.fromFEN(_state.board!.fen);
    final isValidMove = board.move(move);

    if (isValidMove) {
      final expectedMove = _state.currentPuzzle!.moves[_state.currentMoveIndex];
      if (move == expectedMove) {
        final nextMoveIndex = _state.currentMoveIndex + 1;
        final isPuzzleSolved = nextMoveIndex >= _state.currentPuzzle!.moves.length;
        if (!isPuzzleSolved && board.turn == (_state.board!.turn == chess.Color.WHITE ? chess.Color.WHITE : chess.Color.BLACK)) {
          final opponentMove = _state.currentPuzzle!.moves[nextMoveIndex];
          board.move(opponentMove);
        }
        _state = _state.copyWith(
          board: board,
          currentMoveIndex: isPuzzleSolved ? _state.currentMoveIndex : nextMoveIndex,
          isPuzzleSolved: isPuzzleSolved,
          isMoveCorrect: true,
        );
      } else {
        _state = _state.copyWith(isMoveCorrect: false);
      }
    } else {
      _state = _state.copyWith(isMoveCorrect: false);
    }
    notifyListeners();
  }

  void resetPuzzle() {
    if (_state.currentPuzzle == null) return;
    _state = _state.copyWith(
      board: chess.Chess.fromFEN(_state.currentPuzzle!.fen),
      currentMoveIndex: 0,
      isPuzzleSolved: false,
      isMoveCorrect: true,
    );
    notifyListeners();
  }

  void showHint() {
    if (_state.currentPuzzle == null || _state.isPuzzleSolved) return;
    final hintMove = _state.currentPuzzle!.moves[_state.currentMoveIndex];
    _state = _state.copyWith(errorMessage: 'Hint: Try $hintMove');
    notifyListeners();
  }
}