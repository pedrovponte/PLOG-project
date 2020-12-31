choose_board(Id):- 
    get_tabuleiro(Id).
choose_board(_):- write('Invalid input, board doesnt exists'), nl.

%Menu                      
start:-
    nl,nl,
    write('Welcome to Chess Num Solver!'), nl,
    write('(1) Choose existing a board\n'),
    write('(2) Generate Random Puzzle 8x8\n'),
    write('(3) Generate Random Puzzle 16x16\n'),
    write('(4) Exit\n'),
    read(Option),
    nl,nl,
    parseOptions(Option).

parseOptions(1):-
    write('Choose between board 1,2,3,4'),
    read(Id),
    choose_board(Id).  

parseOptions(2):-
    get_puzzle(8).

parseOptions(3):-
    get_puzzle(16).

parseOptions(4).

parseOptions(Other):-
    start.