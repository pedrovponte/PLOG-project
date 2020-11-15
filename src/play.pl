
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
	display_game(GameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),

	selectPiece(GameState, Player, MidGameState, NewRow, NewColumn),
	display_game(MidGameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),

	selectSpotStone(MidGameState, Player, FinalGameState),
	YellowStones1 is YellowStones - 1,
	/*print(NewRow),*/

	/*calculateScore(MidGameState,NewRow,NewColumn,Score),
	Score=1, %auxiliar
	print(Score),*/

	/*Player == yellow, YellowStones1 is YellowStones - 1, turn(FinalGameState, red, YellowStones1, RedStones, YellowScore + Score, RedScore);
	(RedStones1 is RedStones - 1, turn(FinalGameState, yellow, YellowStones, RedStones1, YellowScore, RedScore + Score)).*/
	turnRed(FinalGameState, red, YellowStones1, RedStones, 0, 0).

turnRed(GameState, Player, YellowStones, RedStones, YellowScore, RedScore) :-
	display_game(GameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),

	selectPiece(GameState, Player, MidGameState, NewRow, NewColumn),
	display_game(MidGameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n', RedStones),
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),

	selectSpotStone(MidGameState, Player, FinalGameState),
	RedStones1 is RedStones - 1,
	turnYellow(FinalGameState, yellow, YellowStones, RedStones1, 0, 0).
