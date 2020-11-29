% main function, that initializes the game and calls the game loop
play :-
	initial(GameState),
	Players = [yellow,red],
	random_member(X,Players),
	start_game(GameState, X, 10, 10, 0, 0).

playPVsComputer(Mode) :-
	initial(GameState),
	Players = [yellow,computer],
	random_member(X,Players),
	start_game2(GameState, X, 10, 10, 0, 0,Mode).

playComputerVsComputer(Mode) :-
	initial(GameState),
	start_game3(GameState, computer1, 10, 10, 0, 0,Mode).

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

display_info_2computer(Player, Computer1Score, Computer2Score, Computer1Stones, Computer2Stones) :-
	format('\n ~a turn.\n\n', Player),
	format('Computer 1 (Yellow) has ~d stones to play.\n', Computer1Stones),
	format('Computer 2 (Red) has ~d stones to play.\n', Computer2Stones),
	format('Computer 1 (Yellow) Score: ~d.\n', Computer1Score),
	format('Computer 2 (Red) Score: ~d.\n\n', Computer2Score).

move(GameState, Move, FinalGameState, Player, Jump) :-
	selectPiece(GameState, Player, FinalGameState, Move, Jump).


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

	/*selectPiece(GameState, Player, MidGameState, NewRow, NewColumn, Jump),*/
	move(GameState, Move, MidGameState, Player, Jump),
	Move = [InitRow, InitColumn, NewRow, NewColumn],
	write(InitRow), write(InitColumn), nl, write(NewRow), write(NewColumn), nl,
	display_game(MidGameState, Player),
	display_info(Player, YellowScore, RedScore, YellowStones, RedStones),

	((
		Player == yellow,
		canPutStone(YellowStones, MidGameState, Player, FinalGameState, FinalStones, Jump,'random'),
		getAdjacentes(GameState, NewRow, NewColumn, Adj),
		calculateScore(FinalGameState, Adj, YellowScore, FinalScore),
		checkGameOver(red, NextPlayer, FinalScore)
	);
	(
		Player == red,
		canPutStone(RedStones, MidGameState, Player, FinalGameState, FinalStones, Jump,'random'),
		getAdjacentes(GameState, NewRow, NewColumn, Adj),
		calculateScore(FinalGameState, Adj, RedScore, FinalScore),
		checkGameOver(yellow, NextPlayer, FinalScore)
	)).

/*===========================================================================================================================================*/
/*============================================================PLAYER VS PC===================================================================*/
/*===========================================================================================================================================*/


start_game2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore,Mode) :-
	(
		Player == end,
		endGame(YellowScore,ComputerScore)
	);
	(
		Player == yellow,
		turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer,Mode),
		start_game2(FinalGameState, NextPlayer, FinalStones, ComputerStones, FinalScore, ComputerScore,Mode)
	);
	(
		Player == computer,
		turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer,Mode),
		start_game2(FinalGameState, NextPlayer, YellowStones, FinalStones, YellowScore, FinalScore,Mode)
	).


turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer,Mode) :-

	display_game(GameState, Player),
	display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),

	((
		Player == yellow,
		/*selectPiece(GameState, Player, MidGameState, NewRow, NewColumn, Jump),*/
		move(GameState, Move, MidGameState, Player, Jump),
		Move = [InitRow, InitColumn, NewRow, NewColumn],
		write(InitRow), write(InitColumn), nl, write(NewRow), write(NewColumn), nl,
		display_game(MidGameState, Player),
		display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),
		canPutStone(YellowStones, MidGameState, Player, FinalGameState, FinalStones, Jump,Mode),
		getAdjacentes(GameState, NewRow, NewColumn, Adj),
		calculateScore(FinalGameState, Adj, YellowScore, FinalScore),
		checkGameOver(computer, NextPlayer, FinalScore)
	);
	(
		sleep(3),
		Player == computer,
		choose_move(GameState, red, Mode, Move),
		Move = [InitPos, FinalPos],
		InitPos = [InitRow, InitColumn],
		FinalPos = [FinalRow, FinalColumn],
		replaceValueMatrix(GameState, InitRow, InitColumn, empty, GameState1),
		replaceValueMatrix(GameState1, FinalRow, FinalColumn, red, MidGameState),
		display_game(MidGameState, Player),
		display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),
		format('\nMoved koi from row ~d and column ~d to row ~d and column ~d\n', [InitRow, InitColumn, FinalRow, FinalColumn]),
		sleep(3),
		write('hello\n'),
		checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump),
		canPutStone(ComputerStones, MidGameState, Player, FinalGameState, FinalStones, Jump,Mode),
		write('hello1\n'),
		getAdjacentes(GameState, FinalRow, FinalColumn, Adj),
		write('hello2\n'),
		calculateScore(FinalGameState, Adj, ComputerScore, FinalScore),
		write('hello3\n'),
		checkGameOver(yellow, NextPlayer, FinalScore)
	)).




/*===========================================================================================================================================*/
/*============================================================PC VS PC===================================================================*/
/*===========================================================================================================================================*/


start_game3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score,Mode) :-
	(
		Player == end,
		endGame(PC1Score,PC2Score)
	);
	(
		Player == computer1,
		turn3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, FinalGameState, FinalStones, FinalScore, NextPlayer,Mode),
		start_game3(FinalGameState, NextPlayer, FinalStones, PC2Stones, FinalScore, PC2Score,Mode)
	);
	(
		Player == computer2,
		turn3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, FinalGameState, FinalStones, FinalScore, NextPlayer,Mode),
		start_game3(FinalGameState, NextPlayer, PC1Stones, FinalStones, PC1Score, FinalScore,Mode)
	).


turn3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, FinalGameState, FinalStones, FinalScore, NextPlayer,Mode) :-

	display_game(GameState, Player),
	display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),

	((
		sleep(3),
		Player == computer1,
		choose_move(GameState, yellow, Mode, Move),
		Move = [InitPos, FinalPos],
		InitPos = [InitRow, InitColumn],
		FinalPos = [FinalRow, FinalColumn],
		replaceValueMatrix(GameState, InitRow, InitColumn, empty, GameState1),
		replaceValueMatrix(GameState1, FinalRow, FinalColumn, yellow, MidGameState),
		display_game(MidGameState, Player),
		display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),
		format('\nMoved koi from row ~d and column ~d to row ~d and column ~d\n', [InitRow, InitColumn, FinalRow, FinalColumn]),
		sleep(3),
		write('hello\n'),
		checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump),
		canPutStone(PC2Stones, MidGameState, Player, FinalGameState, FinalStones, Jump,Mode),
		write('hello1\n'),
		getAdjacentes(GameState, FinalRow, FinalColumn, Adj),
		write('hello2\n'),
		calculateScore(FinalGameState, Adj, PC1Score, FinalScore),
		write('hello3\n'),
		checkGameOver(computer2, NextPlayer, FinalScore)
	);
	(
		sleep(3),
		Player == computer2,
		choose_move(GameState, red, Mode, Move),
		Move = [InitPos, FinalPos],
		InitPos = [InitRow, InitColumn],
		FinalPos = [FinalRow, FinalColumn],
		replaceValueMatrix(GameState, InitRow, InitColumn, empty, GameState1),
		replaceValueMatrix(GameState1, FinalRow, FinalColumn, red, MidGameState),
		display_game(MidGameState, Player),
		display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),
		format('\nMoved koi from row ~d and column ~d to row ~d and column ~d\n', [InitRow, InitColumn, FinalRow, FinalColumn]),
		sleep(3),
		write('hello\n'),
		checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump),
		canPutStone(PC2Stones, MidGameState, Player, FinalGameState, FinalStones, Jump,Mode),
		write('hello1\n'),
		getAdjacentes(GameState, FinalRow, FinalColumn, Adj),
		write('hello2\n'),
		calculateScore(FinalGameState, Adj, PC2Score, FinalScore),
		write('hello3\n'),
		checkGameOver(computer1, NextPlayer, FinalScore)
	)).


game_over(GameState, Winner, Player, NextPlayer, FinalScore, Score1, Score2) :-
	checkGameOver(Player, NextPlayer,  FinalScore),
	NextPlayer == end, 
	!,
	Winner == Player.

