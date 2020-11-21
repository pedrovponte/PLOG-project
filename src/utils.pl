checkValueMatrix([H|_T], 0, Column, Content) :-
    checkValueList(H, Column, Content).

checkValueMatrix([_H|T], Row, Column, Content) :-
    Row > 0,
    Row1 is Row - 1,
    checkValueMatrix(T, Row1, Column, Content).

checkValueList([H|_T], 0, Content) :-
    Content = H.

checkValueList([_H|T], Column, Content) :-
    Column > 0,
    Column1 is Column - 1,
    checkValueList(T, Column1, Content).

replaceValueMatrix([H|T], 0, Column, Value, [HSub|T]) :-
    replaceValueList(H, Column, Value, HSub).

replaceValueMatrix([H|T], Row, Column, Value, [H|TSub]) :-
    Row > 0,
    Row1 is Row - 1,
    replaceValueMatrix(T, Row1, Column, Value, TSub).

replaceValueList([_H|T], 0, Value, [Value|T]).

replaceValueList([H|T], Column, Value, [H|TSub]) :-
    Column > 0,
    Column1 is Column - 1,
    replaceValueList(T,Column1,Value, TSub).

copyMatrix(Init, Final) :- accCp(Init,Final).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).



getRedsPosColumn(Board, Value, Row, Column, RedRow, RedCol) :-
    (checkValueMatrix(Board, Row, Column, Value),
    RedRow = Row, RedCol = Column);
    (Column < 6,
    Column1 is Column + 1,
    getRedsPosColumn(Board, Value, Row, Column1, RedRow, RedCol)).

getRedsPosRow(Board, Value, Row, Column, RedRow, RedCol) :-
    getRedsPosColumn(Board, Value, Row, Column, RedRow, RedCol);
    (Row < 6,
    Row1 is Row + 1,
    getRedsPosRow(Board, Value, Row1, Column, RedRow, RedCol)).

/*Percorre o tabuleiro e com a ajuda do predicado checkValueMatrix, devolve 
em RedRow1, RedColumn1, RedRow2 e RedColumn2 as posições dos Reds 
na matriz. */
getRedsPos(Board, RedRow1, RedColumn1, RedRow2, RedColumn2) :-
    Value = red,
    getRedsPosRow(Board,Value, 0,0, RedRow1, RedColumn1),
    replaceValueMatrix(Board, RedRow1, RedColumn1, empty, NewBoard), %substituir red1 por empty para nao ser considerado quando  procurar worker2.
    getRedsPosRow(NewBoard,Value, 0,0, RedRow2, RedColumn2).

/*
findValueInMatrix([H|T], Row, Column) :-
    Row is 0,
    increment(Row,RowPlus),
    indices(H,red,Colunas),
    length(Colunas,l),
    l==0,
    nth0(0,Colunas,Column).

findValueInMatrix([H|T], Row, Column) :-
    Row1 is Row,
    indices(H,red,Colunas),
    length(Colunas,l),
    l\=0,
    indices(T,red,Colunas).

indices(List, E, Is) :-
    findall(N, nth0(N, List, E), Is).


increment(Row,RowPlus):-
    RowPlus is Row + 1.*/