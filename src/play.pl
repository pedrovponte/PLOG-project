% main function, that initializes the game and calls the game loop
play :-
	initial(GameState),
	start_game(GameState).
	/*play(GameState, Player, ScoreR,ScoreY, StonesR,StonesY, Turn).*/

% function to create the board
initial(GameState):-
	initialBoard(GameState).
	% intermediateBoard(GameState).
	% finalBoard(GameState).
	
% function to display the board
display_game(GameState, Player):-
	print_board(GameState).

% by now, yellow player is the first to play, but in the future we can put it random
start_game(GameState) :-
	turnYellow(GameState, yellow, 10, 10, 0, 0).

turnYellow(GameState, Player, YellowStones, RedStones, YellowScore, RedScore) :-
	Player\=end,

	display_game(GameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),

	selectPiece(GameState, Player, MidGameState, NewRow, NewColumn, Jump),
	display_game(MidGameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),
	canPutStone(YellowStones,MidGameState,Player,FinalGameState,NumStonesFinal, Jump),

	getAdjacentes(GameState,NewRow,NewColumn,Adj),
	calculateScore(FinalGameState,Adj,YellowScore,FinalScore),

	checkGameOver(red,NextPlayer,FinalScore),

	turnRed(FinalGameState, NextPlayer, NumStonesFinal, RedStones,FinalScore, RedScore).

turnYellow(_GameState, Player, _YellowStones, _RedStones, YellowScore, RedScore) :-
	Player==end,
	endGame(YellowScore,RedScore).

turnRed(GameState, Player, YellowStones, RedStones, YellowScore, RedScore) :-
	Player\=end,

	display_game(GameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),

	selectPiece(GameState, Player, MidGameState, NewRow, NewColumn, Jump),
	display_game(MidGameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),
	
	canPutStone(RedStones,MidGameState,Player,FinalGameState,NumStonesFinal, Jump),

	getAdjacentes(GameState,NewRow,NewColumn,Adjj),
	calculateScore(FinalGameState,Adjj,RedScore,FinalScore),

	checkGameOver(yellow,NextPlayer,FinalScore),

	turnYellow(FinalGameState, NextPlayer, YellowStones, NumStonesFinal, YellowScore, FinalScore).

turnRed(_GameState, Player, _YellowStones, _RedStones, YellowScore, RedScore) :-
	Player==end,
	endGame(YellowScore,RedScore).

canPutStone(NumStones,MidGameState,Player,FinalGameState,NumStonesFinal, Jump):-
	(NumStones =:= 0; Jump =:= 1),
	NumStonesFinal is NumStones,
	copyMatrix(MidGameState, FinalGameState).

canPutStone(NumStones,MidGameState,Player,FinalGameState, NumStonesFinal, Jump):-
	selectSpotStone(MidGameState, Player, FinalGameState),
	NumStonesFinal is NumStones - 1.
