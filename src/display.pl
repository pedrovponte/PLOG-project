initialBoard([
[0,0,0,0,0,0,0,0,0,0,emptyS,emptyS],
[rs,emptyS,10],
[emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS],
[emptyS,emptyS,red,empty,empty,empty,empty,empty,red,emptyS,emptyS,ss],
[emptyS,emptyS,empty,empty,empty,empty,empty,empty,empty,emptyS,emptyS,t],
[emptyS,emptyS,empty,empty,empty,empty,empty,empty,empty,emptyS,emptyS,o],
[emptyS,emptyS,empty,empty,empty,empty,empty,empty,empty,emptyS,emptyS,n],
[emptyS,emptyS,empty,empty,empty,empty,empty,empty,empty,emptyS,emptyS,e],
[emptyS,emptyS,empty,empty,empty,empty,empty,empty,empty,emptyS,emptyS,ss],
[emptyS,emptyS,yellow,empty,empty,empty,empty,empty,yellow,emptyS,emptyS,emptyS],
[emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS],
[ys,emptyS,10],
[0,0,0,0,0,0,0,0,0,0,emptyS,emptyS]
]).


intermediateBoard([
[1,2,3,0,0,0,0,0,0,0,emptyS,emptyS],
[rs,emptyS,4],
[emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS],
[emptyS,emptyS,empty,empty,empty,stone,empty,empty,empty,emptyS,emptyS,ss],
[emptyS,emptyS,empty,empty,empty,stone,stone,empty,empty,emptyS,emptyS,t],
[emptyS,emptyS,empty,empty,red,empty,empty,empty,stone,emptyS,emptyS,o],
[emptyS,emptyS,empty,stone,yellow,red,empty,stone,empty,emptyS,emptyS,n],
[emptyS,emptyS,stone,empty,stone,stone,empty,yellow,empty,emptyS,emptyS,e],
[emptyS,emptyS,empty,empty,stone,empty,stone,empty,empty,emptyS,emptyS,ss],
[emptyS,emptyS,empty,empty,empty,stone,empty,empty,empty,emptyS,emptyS,emptyS],
[emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS],
[ys,emptyS,4],
[1,2,0,0,0,0,0,0,0,0,emptyS,emptyS]
]).

finalBoard([
[1,2,3,4,5,6,7,8,9,10,emptyS,emptyS],
[rs,emptyS,0],
[emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS],
[emptyS,emptyS,empty,yellow,empty,stone,empty,empty,empty,emptyS,emptyS,ss],
[emptyS,emptyS,empty,stone,yellow,stone,stone,red,red,emptyS,emptyS,t],
[emptyS,emptyS,empty,empty,stone,stone,stone,stone,stone,emptyS,emptyS,o],
[emptyS,emptyS,empty,stone,stone,empty,empty,stone,stone,emptyS,emptyS,n],
[emptyS,emptyS,stone,empty,stone,stone,stone,empty,empty,emptyS,emptyS,e],
[emptyS,emptyS,empty,empty,stone,empty,stone,empty,empty,emptyS,emptyS,ss],
[emptyS,emptyS,empty,empty,empty,stone,empty,empty,empty,emptyS,emptyS,emptyS],
[emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS,emptyS],
[ys,emptyS,0],
[1,2,3,4,5,6,7,8,9,0,emptyS,emptyS]
]).

print_board(X) :-
	write('\n|---|---|---|---|---|---|---|---|---|---|---|---|\n'),
	print_tab(X).

print_tab([]).
print_tab([L|T]):-
	write('|'),
	print_line(L),  
	write('\n|---|---|---|---|---|---|---|---|---|---|---|---|\n'),
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
code(stone, ' O').
code(1, ' 1').
code(2, ' 2').
code(3, ' 3').
code(4, ' 4').
code(5, ' 5').
code(6, ' 6').
code(7, ' 7').
code(8, ' 8').
code(9, ' 9').
code(10, '10').
code(ss, ' S').
code(t, ' T').
code(o, ' O').
code(n, ' N').
code(e, ' E').
code(rs, '                RED SCORE             ').
code(ys, '              YELLOW SCORE            ').
code(0, ' 0').