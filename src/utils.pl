checkValueMatrix([H|_T], 0, Column, Content) :-
    checkValueList(H, Column, Content).

checkValueMatrix([_H|T], Row, Column, Content) :-
    Row > 0,
    Row1 is Row - 1,
    Row2 is Row1,
    Column1 is Column,
    checkValueMatrix(T, Row2, Column1, Content).

checkValueList([H|_T], 0, Content) :-
    Content = H.

checkValueList([_H|T], Column, Content) :-
    Column > 0,
    Column1 is Column - 1,
    Column2 is Column1,
    checkValueList(T, Column2, Content).

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

