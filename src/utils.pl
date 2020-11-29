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

appendList(L1, [], L1).

appendList(L1, L2, L) :-
    append(L1, [L2], L).

appendMoves(_, [], []).
appendMoves(Pos, Moves, Ret):-
  append(Pos, Moves, Ret).

getPlayerPosRow(GameState, List, Row, Column, Player, ListOfPositions) :-
    getPlayerPosRow(GameState, List, Row, Column, Player, [], ListOfPositions).

getPlayerPosRow(_, [], _, 7,_, ListOfPositions, ListOfPositions).

getPlayerPosRow(GameState, [_|T], Row, Column, Player, Moves, ListOfPositions) :-
    (
        checkValueMatrix(GameState, Row, Column, Content),
        Content == Player,
        appendList(Moves, [Row, Column], Res),
        Next is Column + 1,
        getPlayerPosRow(GameState, T, Row, Next, Player, Res, ListOfPositions)
    );
    (
        Next is Column + 1,
        getPlayerPosRow(GameState, T, Row, Next, Player, Moves, ListOfPositions)
    ).

getPlayerPos(GameState, Player, ListOfPositions) :-
    getPlayerPos(GameState, GameState, Player, 0, [], ListOfPositions).

getPlayerPos(_, [], _, 7, ListOfPositions, ListOfPositions).

getPlayerPos(GameState, [H|T], Player, Row, ListInt, ListOfPositions) :-
    getPlayerPosRow(GameState, H, Row, 0, Player, List),
    append(ListInt, List, Res),
    Next is Row + 1,
    getPlayerPos(GameState, T, Player, Next, Res, ListOfPositions).
