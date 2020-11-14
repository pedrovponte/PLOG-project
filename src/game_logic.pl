play(GameState, Player, ScoreR,ScoreY, StonesR,StonesY, Turn):-
    initial(GameState),
%   update_board(GameState, Piece, Position, CapturedPiece, CapturedPiecePos, NewBoard),
    display_game(GameState, Player),
    start_game(GameState),
    calculate_score(GameState, Player, Score, FinalScore1),
%   check_game_over(Board, NewPlayer1, NewPlayer2),

calculate_score([],_,Score, FinalScore):-
    FinalScore = Score,
    !, write(Score).

calculate_score([p(Piece, Pos)|T], Player,Score, FinalScore):-
    member(Piece,Player),
    piece_color(Piece,C1),
    color(Pos,C2),
    (C1==C2 -> NewScore is Score + 3;
    NewScore is Score +1),
    calculate_score(T,Player,NewScore, FinalScore).
  
  calculate_score([p(_, _)|T], Player,Score, FinalScore):-
    calculate_score(T,Player,Score, FinalScore).