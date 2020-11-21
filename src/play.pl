% main function, that initializes the game and calls the game loop
play :-
	initial(GameState),
	start_game(GameState, yellow, 10, 10, 0, 0).
	/*play(GameState, Player, ScoreR,ScoreY, StonesR,StonesY, Turn).*/

playVsComputer :-
	initial(GameState),
	start_game2(GameState, yellow, 10, 10, 0, 0).

% function to create the board
initial(GameState):-
	initialBoard(GameState).
	% intermediateBoard(GameState).
	% finalBoard(GameState).
	% testBoard(GameState).

% function to display the board
display_game(GameState, Player):-
	print_board(GameState).

display_info(Player, YellowScore, RedScore, YellowStones, RedStones) :-
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore).

display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones) :-
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Computer has ~d stones to play.\n', ComputerStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Computer Score: ~d.\n\n', ComputerScore).

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
		getAdjacentes(GameState, NewRow, NewColumn, Adj),
		calculateScore(FinalGameState, Adj, RedScore, FinalScore),
		checkGameOver(yellow, NextPlayer, FinalScore)
	)).

/*===========================================================================================================================================*/
/*===========================================================================================================================================*/


start_game2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore) :-
	(
		Player == end,
		endGame(YellowScore,ComputerScore)
	);
	(
		Player == yellow,
		turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer),
		start_game2(FinalGameState, NextPlayer, FinalStones, ComputerStones, FinalScore, ComputerScore)
	);
	(
		Player == computer,
		turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer),
		start_game2(FinalGameState, NextPlayer, YellowStones, FinalStones, YellowScore, FinalScore)
	).


turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer) :-

	display_game(GameState, Player),
	display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),

	((
		Player == yellow,
		getRedsPos(Board, RedRow1, RedColumn1, RedRow2, RedColumn2),
		selectPiece(GameState, Player, MidGameState, NewRow, NewColumn, Jump),
		display_game(MidGameState, Player),
		display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),
		canPutStone(YellowStones, MidGameState, Player, FinalGameState, FinalStones, Jump),
		getAdjacentes(GameState, NewRow, NewColumn, Adj),
		calculateScore(FinalGameState, Adj, YellowScore, FinalScore),
		checkGameOver(computer, NextPlayer, FinalScore)
	);
	(
		Player == computer,
		getRedsPos(Board, RedRow1, RedColumn1, RedRow2, RedColumn2),
		checkValueMatrix(GameState, RedRow1,RedColumn1,red),
		getAdjacentes(GameState, RedRow1, RedColumn1, Adj),
	/*	bagof(X,member(X,Adj),JogadasPossiveis),*/
		replaceValueMatrix(GameState, RedRow1, RedColumn1, empty, GameState1),
		decideMove(Adj,GameState1,MidGameState,NewRow,NewColumn),
		display_game(MidGameState, Player),
		display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),
		canPutStone(ComputerStones, MidGameState, Player, FinalGameState, FinalStones, 0),
		getAdjacentes(GameState, NewRow, NewColumn, Adj2),
		calculateScore(FinalGameState, Adj2, ComputerScore, FinalScore),
		checkGameOver(yellow, NextPlayer, FinalScore)
	)).


canPutStone(NumStones,MidGameState,Player,FinalGameState,NumStonesFinal, Jump):-
	(NumStones =:= 0; Jump =:= 1),
	NumStonesFinal is NumStones,
	copyMatrix(MidGameState, FinalGameState).

canPutStone(NumStones,MidGameState,Player,FinalGameState, NumStonesFinal, Jump):-
	Player==computer,
	decideStone(MidGameState,FinalGameState),
	NumStonesFinal is NumStones - 1.

canPutStone(NumStones,MidGameState,Player,FinalGameState, NumStonesFinal, Jump):-
	selectSpotStone(MidGameState, Player, FinalGameState),
	NumStonesFinal is NumStones - 1.
