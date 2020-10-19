initialBoard([
[red,empty,empty,empty,empty,empty,red],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[yellow,empty,empty,empty,empty,empty,yellow]
]).

print_board(X) :-
	write('\n|---|---|---|---|---|---|---|\n'),
	print_tab(X).

print_tab([]).

print_tab([L|T]):-
	write('|'),
	print_line(L),  
	write('\n|---|---|---|---|---|---|---|\n'),
	print_tab(T).

print_line([]).

print_line([C|L]):-
	print_cell(C), 
	print_line(L).
	
	
print_cell(C):-
	code(C,P), write(P), write(' |').
	
code(empty, '  ').
code(red, 'RF').
code(yellow, 'YF').
code(stone, 'SS').