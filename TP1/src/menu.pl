% Menu display

printMenu :-
	write('\n\n________________________________________________________________ \n'),
    write('|                                                              |\n'),
    write('|                                                              |\n'),
    write('|               _ _____ _   _    _      _____                  |\n'),
    write('|              | |_   _| | | |  | |    |_   _|                 |\n'),
    write('|              | | | | | |_/ |  | |      | |                   |\n'),
    write('|          _   | | | | |  _  |  | |      | |                   |\n'),
    write('|         | |__| |_| |_| / | |  | |____ _| |_                  |\n'),
    write('|         |______|_____|_| |_|  |______|_____|                 |\n'),
    write('|                                                              |\n'),
    write('|                                                              |\n'),
    write('|       1. Player vs Player (7x7)                              |\n'),
    write('|       2. Player vs Player (9x9)                              |\n'),
    write('|       3. Player vs Computer (7x7 - Easy Level - Random)      |\n'),
    write('|       4. Player vs Computer (9x9 - Easy Level - Random)      |\n'),
    write('|       5. Player vs Computer (7x7 - Hard Level - Greedy)      |\n'),
    write('|       6. Player vs Computer (9x9 - Hard Level - Greedy)      |\n'),
    write('|       7. Computer vs Player (7x7 - Easy Level - Random)      |\n'),
    write('|       8. Computer vs Player (9x9 - Easy Level - Random)      |\n'),
    write('|       9. Computer vs Player (7x7 - Hard Level - Greedy)      |\n'),
    write('|       10. Computer vs Player (9x9 - Hard Level - Greedy)     |\n'),
    write('|       11. Computer vs Computer (7x7 - Easy Level - Random)   |\n'),
    write('|       12. Computer vs Computer (9x9 - Easy Level - Random)   |\n'),
    write('|       13. Computer vs Computer (7x7 - Hard Level - Greedy)   |\n'),
    write('|       14. Computer vs Computer (9x9 - Hard Level - Greedy)   |\n'),
    write('|       15. Computer vs Computer (7x7 - Greedy vs Random)      |\n'),
    write('|       16. Computer vs Computer (9x9 - Greedy vs Random)      |\n'),
    write('|                                                              |\n'),
    write('|       0. Exit                                                |\n'),
    write('|                                                              |\n'),
    write('|                                                              |\n'),
    write('|______________________________________________________________| \n').

selectMenuOption :-
    write('\nSelect an option: '),
    read(Option),
    checkOption(Option, NewOption),
    selectAction(NewOption).

% Validating input 

checkOption(0, 0).
checkOption(1, 1).
checkOption(2, 2).
checkOption(3, 3).
checkOption(4, 4).
checkOption(5, 5).
checkOption(6, 6).
checkOption(7, 7).
checkOption(8, 8).
checkOption(9, 9).
checkOption(10, 10).
checkOption(11, 11).
checkOption(12, 12).
checkOption(13, 13).
checkOption(14, 14).
checkOption(15, 15).
checkOption(16, 16).

checkOption(_, NewOption) :-
    write('\nInvalid option\nSelect again\n'),
    readColumn(Option),
    checkColumn(Option, NewOption).

% Calling play predicate acording to the the chosen option

selectAction(0) :-
    write('\nExiting...\n').

selectAction(1) :-
    write('\nStarting game Player vs Player (7x7)...\n\n'),
    play(7).

selectAction(2) :-
    write('\nStarting game Player vs Player (9x9)...\n\n'),
    play(9).

selectAction(3) :-
    write('\nStarting game Player vs Computer - Easy Level (7x7)...\n\n'),
    playPVsComputer(7, 'random').

selectAction(4) :-
    write('\nStarting game Player vs Computer - Easy Level (9x9)...\n\n'),
    playPVsComputer(9, 'random').

selectAction(5) :-
    write('\nStarting game Player vs Computer - Hard Level (7x7)...\n\n'),
    playPVsComputer(7, 'greedy').

selectAction(6) :-
    write('\nStarting game Player vs Computer - Hard Level (9x9)...\n\n'),
    playPVsComputer(7, 'greedy').

selectAction(7) :-
    write('\nStarting game Computer vs Player - Easy Level (7x7)...\n\n'),
    computervsPlayer(7, 'random').

selectAction(8) :-
    write('\nStarting game Computer vs Player - Easy Level (9x9)...\n\n'),
    computervsPlayer(9, 'random').

selectAction(9) :-
    write('\nStarting game Computer vs Player - Hard Level (7x7)...\n\n'),
    computervsPlayer(7, 'greedy').

selectAction(10) :-
    write('\nStarting game Computer vs Player - Hard Level (9x9)...\n\n'),
    computervsPlayer(9, 'greedy').

selectAction(11) :-
    write('\nStarting game Computer vs Computer - Easy Level (7x7)...\n\n'),
    playComputerVsComputer(7, 'random').

selectAction(12) :-
    write('\nStarting game Computer vs Computer - Easy Level (9x9)...\n\n'),
    playComputerVsComputer(9, 'random').

selectAction(13) :-
    write('\nStarting game Computer vs Computer - Hard Level (7x7)...\n\n'),
    playComputerVsComputer(7, 'greedy').

selectAction(14) :-
    write('\nStarting game Computer vs Computer - Hard Level (9x9)...\n\n'),
    playComputerVsComputer(9, 'greedy').

selectAction(15) :-
    write('\nStarting game Computer vs Computer - Greedy vs Random (7x7)...\n\n'),
    playGreedyVsRandom(7).

selectAction(16) :-
    write('\nStarting game Computer vs Computer - Greedy vs Random (9x9)...\n\n'),
    playGreedyVsRandom(9).