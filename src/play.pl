% Main function, that initializes the game and calls the game loop
play(Size) :-
	initial(GameState, Size),
	Players = [yellow,red],
	random_member(X,Players),
	start_game(GameState, red, 7, 3, 7, 9, Size).

playPVsComputer(Size, Mode) :-
	initial(GameState, Size),
	Players = [yellow,computer],
	random_member(X,Players),
	start_game2(GameState, X, 10, 10, 0, 0, Mode, Size).

playComputerVsComputer(Size, Mode) :-
	initial(GameState, Size),
	start_game3(GameState, computer1, 10, 10, 0, 0, Mode, Size).

% Predicate that creates the board
initial(GameState, Size):-
	generateRandomBoard(GameState, Size).
	% initialBoard(GameState).
	% intermediateBoard(GameState).
	% finalBoard(GameState).
	% testBoard(GameState).

% Predicate that displays the board
display_game(GameState, Player):-
	printBoard(GameState).

%Predicate to display Scores and number of Stones of each Player
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

start_game(GameState, Player, YellowStones, RedStones, YellowScore, RedScore, Size) :-
	(
		Player == end,
		endGame(YellowScore,RedScore)
	);
	(
		Player == yellow,
		turn(GameState, Player, YellowStones, RedStones, YellowScore, RedScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Size),
		start_game(FinalGameState, NextPlayer, FinalStones, RedStones, FinalScore, RedScore, Size)
	);
	(
		Player == red,
		turn(GameState, Player, YellowStones, RedStones, YellowScore, RedScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Size),
		start_game(FinalGameState, NextPlayer, YellowStones, FinalStones, YellowScore, FinalScore, Size)
	).

turn(GameState, Player, YellowStones, RedStones, YellowScore, RedScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Size) :-

	display_game(GameState, Player),
	display_info(Player, YellowScore, RedScore, YellowStones, RedStones),

	move(GameState, Move, MidGameState, Player, Jump),
	Move = [InitRow, InitColumn, NewRow, NewColumn],
	display_game(MidGameState, Player),
	display_info(Player, YellowScore, RedScore, YellowStones, RedStones),

	((
		Player == yellow,
		canPutStone(YellowStones, MidGameState, Player, FinalGameState, FinalStones, Jump, 'random', Size),
		getAdjacentes(GameState, NewRow, NewColumn, Adj, Size),
		calculateScore(FinalGameState, Adj, YellowScore, FinalScore),
		checkGameOver(red, NextPlayer, FinalScore)
	);
	(
		Player == red,
		canPutStone(RedStones, MidGameState, Player, FinalGameState, FinalStones, Jump, 'random', Size),
		getAdjacentes(GameState, NewRow, NewColumn, Adj, Size),
		calculateScore(FinalGameState, Adj, RedScore, FinalScore),
		checkGameOver(yellow, NextPlayer, FinalScore)
	)).

/*===========================================================================================================================================*/
/*============================================================PLAYER VS PC===================================================================*/
/*===========================================================================================================================================*/


start_game2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, Mode, Size) :-
	(
		Player == end,
		endGame(YellowScore,ComputerScore)
	);
	(
		Player == yellow,
		turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size),
		start_game2(FinalGameState, NextPlayer, FinalStones, ComputerStones, FinalScore, ComputerScore, Mode, Size)
	);
	(
		Player == computer,
		turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size),
		start_game2(FinalGameState, NextPlayer, YellowStones, FinalStones, YellowScore, FinalScore, Mode, Size)
	).


turn2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size) :-

	display_game(GameState, Player),
	display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),

	((
		Player == yellow,
		/*selectPiece(GameState, Player, MidGameState, NewRow, NewColumn, Jump),*/
		move(GameState, Move, MidGameState, Player, Jump, Size),
		Move = [InitRow, InitColumn, NewRow, NewColumn],
		display_game(MidGameState, Player),
		display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),
		canPutStone(YellowStones, MidGameState, Player, FinalGameState, FinalStones, Jump, Mode, Size),
		getAdjacentes(GameState, NewRow, NewColumn, Adj, Size),
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
		checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump),
		canPutStone(ComputerStones, MidGameState, Player, FinalGameState, FinalStones, Jump, Mode, Size),
		getAdjacentes(GameState, FinalRow, FinalColumn, Adj, Size),
		calculateScore(FinalGameState, Adj, ComputerScore, FinalScore),
		checkGameOver(yellow, NextPlayer, FinalScore)
	)).




/*===========================================================================================================================================*/
/*============================================================PC VS PC===================================================================*/
/*===========================================================================================================================================*/


start_game3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, Mode, Size) :-
	(
		Player == end,
		endGame(PC1Score,PC2Score)
	);
	(
		Player == computer1,
		turn3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size),
		start_game3(FinalGameState, NextPlayer, FinalStones, PC2Stones, FinalScore, PC2Score, Mode, Size)
	);
	(
		Player == computer2,
		turn3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size),
		start_game3(FinalGameState, NextPlayer, PC1Stones, FinalStones, PC1Score, FinalScore, Mode, Size)
	).


turn3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size) :-

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
		checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump),
		canPutStone(PC2Stones, MidGameState, Player, FinalGameState, FinalStones, Jump, Mode, Size),
		getAdjacentes(GameState, FinalRow, FinalColumn, Adj, Size),
		calculateScore(FinalGameState, Adj, PC1Score, FinalScore),
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
		checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump),
		canPutStone(PC2Stones, MidGameState, Player, FinalGameState, FinalStones, Jump, Mode, Size),
		getAdjacentes(GameState, FinalRow, FinalColumn, Adj, Size),
		calculateScore(FinalGameState, Adj, PC2Score, FinalScore),
		checkGameOver(computer1, NextPlayer, FinalScore)
	)).


% Move validation and execution, obtaining the new game state 
move(GameState, Move, FinalGameState, Player, Jump) :-
	selectPiece(GameState, Player, FinalGameState, Move, Jump).

% Evaluation about the end of the game
game_over(GameState, Winner, Player, NextPlayer, FinalScore, Score1, Score2) :-
	checkGameOver(Player, NextPlayer,  FinalScore),
	NextPlayer == end, 
	!,
	Winner == Player.

