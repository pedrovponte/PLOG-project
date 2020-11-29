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
    write('|       1. Player vs Player (6x6)                              |\n'),
    write('|       2. Player vs Player (8x8)                              |\n'),
    write('|       3. Player vs Computer (6x6 - Easy Level - Random)      |\n'),
    write('|       4. Player vs Computer (6x6 - Hard Level - Greedy)      |\n'),
    write('|       5. Computer vs Computer (6x6 - Easy Level - Random)    |\n'),
    write('|       6. Computer vs Computer (6x6 - Hard Level - Greedy)    |\n'),
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

checkOption(0, 0).
checkOption(1, 1).
checkOption(2, 2).
checkOption(3, 3).
checkOption(4, 4).
checkOption(5, 5).
checkOption(6, 6).

checkOption(_, NewOption) :-
    write('\nInvalid option\nSelect again\n'),
    readColumn(Option),
    checkColumn(Option, NewOption).

selectAction(0) :-
    write('\nExiting...\n').

selectAction(1) :-
    write('\nStarting game Player vs Player (6x6)...\n\n'),
    play.

selectAction(2) :-
    write('\nStarting game Player vs Player (8x8)...THIS IS NOT IMPLEMENTED YET\n\n').

selectAction(3) :-
    write('\nStarting game Player vs Computer - Easy Level...\n\n'),
    playPVsComputer('random').

selectAction(4) :-
    write('\nStarting game Player vs Computer - Hard Level...\n\n'),
    playPVsComputer('greedy').

selectAction(5) :-
    write('\nStarting game Computer vs Computer - Easy Level...\n\n'),
    playComputerVsComputer('random').

selectAction(6) :-
    write('\nStarting game Computer vs Computer - Hard Level...\n\n'),
    playComputerVsComputer('greedy').