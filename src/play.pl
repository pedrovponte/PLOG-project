% main function, that initializes the game and calls the game loop
play :-
	initial(GameState),
	start_game(GameState, yellow, 0, 0, 5, 9).
	/*play(GameState, Player, ScoreR,ScoreY, StonesR,StonesY, Turn).*/

% function to create the board
initial(GameState):-
	% initialBoard(GameState).
	% intermediateBoard(GameState).
	% finalBoard(GameState).
	testBoard(GameState).

% function to display the board
display_game(GameState, Player):-
	print_board(GameState).

display_info(Player, YellowScore, RedScore, YellowStones, RedStones) :-
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore).

% by now, yellow player is the first to play, but in the future we can put it random
start_game(GameState, Player, YellowStones, RedStones, YellowScore, RedScore) :-
	(
		Player == end,
		endGame(YellowScore,RedScore)
	);
	(
		Player == yellow,
		turn(GameState, Player, YellowStones, RedStones, YellowScore, RedScore, FinalGameState, FinalStones, FinalScore, NextPlayer),
		start_game(FinalGameState, NextPlayer, FinalStones, RedStones, FinalScore, RedScore)
	);
	(
		Player == red,
		turn(GameState, Player, YellowStones, RedStones, YellowScore, RedScore, FinalGameState, FinalStones, FinalScore, NextPlayer),
		start_game(FinalGameState, NextPlayer, YellowStones, FinalStones, YellowScore, FinalScore)
	).

turn(GameState, Player, YellowStones, RedStones, YellowScore, RedScore, FinalGameState, FinalStones, FinalScore, NextPlayer) :-

	display_game(GameState, Player),
	display_info(Player, YellowScore, RedScore, YellowStones, RedStones),

	selectPiece(GameState, Player, MidGameState, NewRow, NewColumn, Jump),
	display_game(MidGameState, Player),
	display_info(Player, YellowScore, RedScore, YellowStones, RedStones),

	((
		Player == yellow,
		canPutStone(YellowStones, MidGameState, Player, FinalGameState, FinalStones, Jump),
		getAdjacentes(GameState, NewRow, NewColumn, Adj),
		calculateScore(FinalGameState, Adj, YellowScore, FinalScore),
		checkGameOver(red, NextPlayer, FinalScore)
	);
	(
		Player == red,
		canPutStone(RedStones, MidGameState, Player, FinalGameState, FinalStones, Jump),
		write('Hello6\n'),
		getAdjacentes(GameState, NewRow, NewColumn, Adj),
		write('Hello7\n'),
		calculateScore(FinalGameState, Adj, RedScore, FinalScore),
		write('Hello8\n'),
		checkGameOver(yellow, NextPlayer, FinalScore)
	)).

canPutStone(NumStones,MidGameState,Player,FinalGameState,NumStonesFinal, Jump):-
	write('Hello1\n'),
	(NumStones =:= 0; Jump =:= 1),
	write('Hello2\n'),
	NumStonesFinal is NumStones,
	write('Hello3\n'),
	copyMatrix(MidGameState, FinalGameState).

canPutStone(NumStones,MidGameState,Player,FinalGameState, NumStonesFinal, Jump):-
	write('Hello4\n'),
	selectSpotStone(MidGameState, Player, FinalGameState),
	write('Hello5\n'),
	NumStonesFinal is NumStones - 1.
