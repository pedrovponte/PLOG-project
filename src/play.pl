play :-
	initial(GameState),
	display_game(GameState, Player).

initial(GameState):-
	initialBoard(GameState).
	
display_game(GameState, Player):-
	print_board(GameState).