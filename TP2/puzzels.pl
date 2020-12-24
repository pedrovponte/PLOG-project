puzzle1([[empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,4,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,4,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty],
    [0,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,4,empty,empty,empty,empty,empty]]).

printBoard(GameBoard) :-
    length(GameBoard, Size),
    nl,
    write('  '),
    printHeader(Size),
    printBoard(GameBoard, 0, Size).

printHeader(Size) :-
    printNumber(0, Size),
    nl,
    write('  '),
    printRowSeparator(0, Size),
    nl.

printNumber(Size, Size).

printNumber(Act, Size) :-
    write('  '),
    write(Act),
    write(' '),
    NewAct is Act + 1,
    printNumber(NewAct, Size).

printRowSeparator(Size, Size) :- write('|').

printRowSeparator(Act, Size) :-
    write('|---'),
    NewAct is Act + 1,
    printRowSeparator(NewAct, Size).

printBoard([], Size, Size).

printBoard([L|T], N, Size):-
    letter(N,X),
    N1 is N + 1,
    write(X),
    write(' '),
    write('|'),
    print_line(L),  
    nl,
    write('  '),
    printRowSeparator(0, Size),
    nl,
    printBoard(T,N1, Size).

print_line([]).

print_line([C|L]):-
    print_cell(C), 
    print_line(L).
    
print_cell(C):-
    code(C,P),
    write(P),
    write(' |').

code(empty, '  ').
code(king, ' K'). /*rei*/
code(queen, ' Q'). /*rainha*/
code(rook, ' T'). /*torre*/
code(bishop, ' B'). /*bispo*/
code(knight, ' C'). /*cavaleiro*/
code(pawn, ' P'). /*peao*/