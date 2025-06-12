import 'package:equatable/equatable.dart';
import 'package:chess/chess.dart' as chess;

class ChessPuzzle extends Equatable {
  final String puzzleId;
  final String fen;
  final int rating;
  final List<String> moves;
  final List<String> themes;

  const ChessPuzzle({
    required this.puzzleId,
    required this.fen,
    required this.rating,
    required this.moves,
    required this.themes,
  });

  @override
  List<Object> get props => [puzzleId, fen, rating, moves, themes];
}

class ChessState extends Equatable {
  final ChessPuzzle? currentPuzzle;
  final chess.Chess? board;
  final int currentMoveIndex;
  final bool isPuzzleSolved;
  final bool isMoveCorrect;
  final String? errorMessage;
  final bool isLoading;

  const ChessState({
    this.currentPuzzle,
    this.board,
    this.currentMoveIndex = 0,
    this.isPuzzleSolved = false,
    this.isMoveCorrect = true,
    this.errorMessage,
    this.isLoading = false,
  });

  ChessState copyWith({
    ChessPuzzle? currentPuzzle,
    chess.Chess? board,
    int? currentMoveIndex,
    bool? isPuzzleSolved,
    bool? isMoveCorrect,
    String? errorMessage,
    bool? isLoading,
  }) {
    return ChessState(
      currentPuzzle: currentPuzzle ?? this.currentPuzzle,
      board: board ?? this.board,
      currentMoveIndex: currentMoveIndex ?? this.currentMoveIndex,
      isPuzzleSolved: isPuzzleSolved ?? this.isPuzzleSolved,
      isMoveCorrect: isMoveCorrect ?? this.isMoveCorrect,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        currentPuzzle,
        board,
        currentMoveIndex,
        isPuzzleSolved,
        isMoveCorrect,
        errorMessage,
        isLoading,
      ];
}