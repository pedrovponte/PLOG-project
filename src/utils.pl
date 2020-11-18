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
