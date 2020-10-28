initialBoard([
[1,2,3,4,5,6,7],
[8,9,rs,emptyS,p,n,t],
[emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS],
[red,empty,empty,empty,empty,empty,red],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[yellow,empty,empty,empty,empty,empty,yellow],
[emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS],
[1,2,3,4,5,6,7],
[8,9,ys,emptyS,p,n,t]
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
code(emptyS, '--').
code(red, 'RF').
code(yellow, 'YF').
code(stone, 'SS').
code(1, ' 1').
code(2, ' 2').
code(3, ' 3').
code(4, ' 4').
code(5, ' 5').
code(6, ' 6').
code(7, ' 7').
code(8, ' 8').
code(9, ' 9').
code(p, ' P').
code(n, ' N').
code(t, ' T').
code(rs, 'RS').
code(ys, 'YS').