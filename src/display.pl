initialBoard([
[red,empty,empty,empty,empty,empty,red],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[yellow,empty,empty,empty,empty,empty,yellow]
]).

intermediateBoard([
[empty,empty,empty,stone,empty,empty,empty],
[empty,empty,empty,stone,stone,empty,empty],
[empty,empty,red,empty,empty,empty,stone],
[empty,stone,yellow,red,empty,stone,empty],
[stone,empty,stone,stone,empty,yellow,empty],
[empty,empty,stone,empty,stone,empty,empty],
[empty,empty,empty,stone,empty,empty,empty]
]).

finalBoard([
[empty,yellow,empty,stone,empty,empty,empty],
[empty,stone,yellow,stone,stone,red,red],
[empty,empty,stone,stone,stone,stone,stone],
[empty,stone,stone,empty,empty,stone,stone],
[stone,empty,stone,stone,stone,empty,empty],
[empty,empty,stone,empty,stone,empty,empty],
[empty,empty,empty,stone,empty,empty,empty]
]).

testBoard([
[empty,stone,empty,empty,empty,empty,empty],
[empty,stone,stone,stone,empty,empty,empty],
[empty,red,stone,stone,empty,empty,empty],
[empty,stone,red,empty,empty,empty,empty],
[yellow,stone,stone,stone,empty,empty,empty],
[empty,stone,stone,empty,stone,stone,empty],
[yellow,stone,empty,stone,empty,empty,empty]
]).

generateRandomBoard(GameBoard, Size) :-
    buildBoard([], MidGameBoard, 0, Size), 
    replaceValueMatrix(MidGameBoard, 0, 0, red, MidGameBoard1),
    replaceValueMatrix(MidGameBoard1, 0, Size - 1, red, MidGameBoard2),
    replaceValueMatrix(MidGameBoard2, Size - 1, 0, yellow, MidGameBoard3),
    replaceValueMatrix(MidGameBoard3, Size - 1, Size - 1, yellow, GameBoard).


buildBoard(FinalBoard, FinalBoard, Size, Size).

buildBoard(InitBoard, FinalBoard, ActRow, Size) :-
    buildRow([], FinalRow, Size, 0),
    append(InitBoard, FinalRow, NewBoard),
    NewActRow is ActRow + 1,
    buildBoard(NewBoard, FinalBoard, NewActRow, Size).


buildRow(InitRow, FinalRow, Size, Size) :- FinalRow = [InitRow].

buildRow(InitRow, FinalRow, Size, ActColumn) :-
    append(InitRow, [empty], NewRow),
    NewActColumn is ActColumn + 1,
    buildRow(NewRow, FinalRow, Size, NewActColumn).

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
code(red, 'RF').
code(yellow, 'YF').
code(stone, ' O').

letter(0, 'A').
letter(1, 'B').
letter(2, 'C').
letter(3, 'D').
letter(4, 'E').
letter(5, 'F').
letter(6, 'G').
letter(7, 'H').
letter(8, 'I').
letter(9, 'J').
