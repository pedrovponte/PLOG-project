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
[empty,empty,empty,stone,empty,empty,empty],
[empty,red,empty,empty,empty,red,empty],
[empty,empty,empty,empty,stone,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,yellow,empty,empty],
[empty,yellow,stone,stone,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty]
]).

print_board(X) :-
	nl,
	write('    0   1   2   3   4   5   6 \n'),
	write('  |---|---|---|---|---|---|---|\n'),
	print_tab(X,0).

print_tab([],7).
print_tab([L|T],N):-
	letter(N,X),
	N1 is N + 1,
	write(X),
	write(' '),
	write('|'),
	print_line(L),  
	write('\n  |---|---|---|---|---|---|---|\n'),
	print_tab(T,N1).

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
