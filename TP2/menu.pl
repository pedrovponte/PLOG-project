choose_board(Id):- 
    Id<11,
    get_tabuleiro(Id).
choose_board(Id):-
    Id==11,
    get_tabuleiro2(Id).
choose_board(Id):-
    Id==12,
    get_tabuleiro2(Id).
choose_board(_):- write('Invalid input, board doesn''t exist'), nl.

%Menu                      
start:-
    nl,nl,
    write('Welcome to Chess Num Solver!'), nl,
    write('(1) Choose existing a board\n'),
    write('(2) Generate Random Puzzle 8x8\n'),
    write('(3) Generate Random Puzzle 16x16\n'),
    write('(4) Generate Random Puzzle 21x21\n'),
    write('(5) Generate Random Puzzle 35x35\n'),
    write('(6) Generate Random Puzzle 50x50\n'),
    write('(7) Generate Random Puzzle 100x100\n'),
    write('(8) Exit\n'),
    read(Option),
    nl,nl,
    parseOptions(Option).

parseOptions(1):-
    write('Choose between board 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11(Puzzle 0 16x16), 12(Puzzle 0 32x32)'),
    read(Id),
    choose_board(Id).  

parseOptions(2):-
    get_puzzle(8).

parseOptions(3):-
    get_puzzle(16).

parseOptions(4):-
    get_puzzle(21).

parseOptions(5):-
    get_puzzle(35).

parseOptions(6):-
    get_puzzle(50).

parseOptions(7):-
    get_puzzle(100).

parseOptions(8).

parseOptions(Other):-
    start.