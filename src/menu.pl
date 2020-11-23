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
    write('|          1. Player vs Player (6x6)                           |\n'),
    write('|          4. Player vs Computer (6x6 - Level 0)               |\n'),
    write('|          5. Computer vs Player (6x6 - Level 0)               |\n'),
    write('|          6. Computer vs Computer (6x6 - Level 0)             |\n'),
    write('|                                                              |\n'),
    write('|          0. Exit                                             |\n'),
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
    write('\nStarting game...\n\n'),
    play.

selectAction(4) :-
    write('\nStarting game...\n\n'),
    playVsComputer.
