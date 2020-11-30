% Main function, that initializes the game and calls the game loop
play(Size) :-
	initial(GameState, Size),
	Players = [yellow, red],
	random_member(X, Players),
	start_game(GameState, X, 10, 10, 0, 0, Size).

playPVsComputer(Size, Mode) :-
	initial(GameState, Size),
	start_game2(GameState, yellow, 10, 10, 0, 0, Mode, Size).

computervsPlayer(Size, Mode) :-
	initial(GameState, Size),
	start_game2(GameState, computer, 10, 10, 0, 0, Mode, Size).

playComputerVsComputer(Size, Mode) :-
	initial(GameState, Size),
	start_game3(GameState, computer1, 10, 10, 0, 0, Mode, Size).

playGreedyVsRandom(Size) :-
	initial(GameState, Size),
	start_game4(GameState, computer1, 10, 10, 0, 0, Size).

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

% Predicate to display Scores and number of Stones of each Player
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


% Start Game Player vs Player

start_game(GameState, Player, YellowStones, RedStones, YellowScore, RedScore, Size) :-
	(
		Player == end,
		display_game(GameState, Player),
		display_info(Player, YellowScore, RedScore, YellowStones, RedStones),
		endGame(YellowScore,RedScore)
	);
	(
		Player == yellow,
		display_game(GameState, Player),
		display_info(Player, YellowScore, RedScore, YellowStones, RedStones),
		turn(GameState, Player, YellowStones, YellowScore,  FinalGameState, FinalStones, FinalScore, NextPlayer, Size),
		checkGameOver(red, NextPlayer, FinalScore),
		start_game(FinalGameState, NextPlayer, FinalStones, RedStones, FinalScore, RedScore, Size)
	);
	(
		Player == red,
		display_game(GameState, Player),
		display_info(Player, YellowScore, RedScore, YellowStones, RedStones),
		turn(GameState, Player, RedStones, RedScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Size),
		checkGameOver(yellow, NextPlayer, FinalScore),
		start_game(FinalGameState, NextPlayer, YellowStones, FinalStones, YellowScore, FinalScore, Size)
	).


turn(GameState,Player,Stones,Score,FinalGameState, FinalStones, FinalScore, NextPlayer, Size):-
	move(GameState, Move, MidGameState, Player, Jump, Size),
	Move = [InitRow, InitColumn, NewRow, NewColumn],
	display_game(MidGameState, Player),
	checkJump(InitRow, InitColumn, NewRow, NewColumn, Jump),
	canPutStone(Stones, MidGameState, Player, FinalGameState, FinalStones, Jump, 'random', Size),
	getAdjacentes(GameState, NewRow, NewColumn, Adj, Size),
	calculateScore(FinalGameState, Adj, Score, FinalScore).


% Start Game Player vs Computer

start_game2(GameState, Player, YellowStones, ComputerStones, YellowScore, ComputerScore, Mode, Size) :-
	(
		Player == end,
		display_game(GameState, Player),
		display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),
		endGame(YellowScore,ComputerScore)
	);
	(
		Player == yellow,
		display_game(GameState, Player),
		display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),
		turn(GameState, Player, YellowStones, YellowScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Size),
		checkGameOver(computer, NextPlayer, FinalScore),
		start_game2(FinalGameState, NextPlayer, FinalStones, ComputerStones, FinalScore, ComputerScore, Mode, Size)
	);
	(
		Player == computer,
		display_game(GameState, Player),
		display_info_computer(Player, YellowScore, ComputerScore, YellowStones, ComputerStones),
		turn2(GameState, Player, ComputerStones,  ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size),
		checkGameOver(yellow, NextPlayer, FinalScore),
		start_game2(FinalGameState, NextPlayer, YellowStones, FinalStones, YellowScore, FinalScore, Mode, Size)
	).


evaluate(Player,J):-
	(Player == computer, J=red);
	(Player == computer1, J=yellow);
	(Player == computer2, J=red).

turn2(GameState, Player, ComputerStones, ComputerScore, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size) :-
	sleep(3),
	evaluate(Player,J),
	choose_move(GameState, J, Mode, Move, Size),
	Move = [InitPos, FinalPos],
	InitPos = [InitRow, InitColumn],
	FinalPos = [FinalRow, FinalColumn],
	replaceValueMatrix(GameState, InitRow, InitColumn, empty, GameState1),
	replaceValueMatrix(GameState1, FinalRow, FinalColumn, J, MidGameState),
	display_game(MidGameState, Player),
	format('\nMoved koi from row ~d and column ~d to row ~d and column ~d\n', [InitRow, InitColumn, FinalRow, FinalColumn]),
	sleep(3),
	checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump),
	canPutStone(ComputerStones, MidGameState, Player, FinalGameState, FinalStones, Jump, Mode, Size),
	getAdjacentes(GameState, FinalRow, FinalColumn, Adj, Size),
	calculateScore(FinalGameState, Adj, ComputerScore, FinalScore).


% Start Game Computer vs Computer

start_game3(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, Mode, Size) :-
	(
		Player == end,
		display_game(GameState, Player),
		display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),
		endGame(PC1Score,PC2Score)
	);
	(
		Player == computer1,
		display_game(GameState, Player),
		display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),
		turn2(GameState, Player, PC1Stones, PC1Score, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size),
		checkGameOver(computer2, NextPlayer, FinalScore),
		start_game3(FinalGameState, NextPlayer, FinalStones, PC2Stones, FinalScore, PC2Score, Mode, Size)
	);
	(
		Player == computer2,
		display_game(GameState, Player),
		display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),
		turn2(GameState, Player, PC2Stones, PC2Score, FinalGameState, FinalStones, FinalScore, NextPlayer, Mode, Size),
		checkGameOver(computer1, NextPlayer, FinalScore),
		start_game3(FinalGameState, NextPlayer, PC1Stones, FinalStones, PC1Score, FinalScore, Mode, Size)
	).


% Start Game Greedy vs Random

start_game4(GameState, Player, PC1Stones, PC2Stones, PC1Score, PC2Score, Size):-
	(
		Player == end,
		display_game(GameState, Player),
		display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),
		endGame(PC1Score,PC2Score)
	);
	(
		Player == computer1,
		display_game(GameState, Player),
		display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),
		write('Computer 1 (Yellow) - Random player.\n'),
		turn2(GameState, Player, PC1Stones, PC1Score,  FinalGameState, FinalStones, FinalScore, NextPlayer,'random', Size),
		checkGameOver(computer2, NextPlayer, FinalScore),
		start_game4(FinalGameState, NextPlayer, FinalStones, PC2Stones, FinalScore, PC2Score, Size)
	);
	(
		Player == computer2,
		display_game(GameState, Player),
		display_info_2computer(Player, PC1Score, PC2Score, PC1Stones, PC2Stones),
		write('Computer 2 (Red) - Greedy player.\n'),
		turn2(GameState, Player, PC2Stones, PC2Score, FinalGameState, FinalStones, FinalScore, NextPlayer,'greedy', Size),
		checkGameOver(computer1, NextPlayer, FinalScore),
		start_game4(FinalGameState, NextPlayer, PC1Stones, FinalStones, PC1Score, FinalScore, Size)
	).

