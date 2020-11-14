% main function, that initializes the game and calls the game loop
play :-
	initial(GameState),
	display_game(GameState, Player),
	start_game(GameState).

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
	turn(GameState, yellow, 10, 10).

turn(GameState, Player, YellowStones, RedStones) :-
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n\n', RedStones),
	selectPiece(GameState, Player, MidGameState),
	display_game(MidGameState, Player),
	format('\n ~a turn.\n\n', Player),
	format('Yellow player has ~d stones to play.\n', YellowStones),
	format('Red player has ~d stones to play.\n\n', RedStones).
	/*selectSpotStone(MidGameState, Player, FinalGameState).*/