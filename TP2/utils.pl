

% Generate List

length_list(N, List) :- length(List, N).
generate_matrix(Cols, Rows, Matrix) :-
    length_list(Rows, Matrix),
    maplist(length_list(Cols), Matrix).

maplist(_, []).
maplist(C, [X|Xs]) :-
   call(C,X),
   maplist(C, Xs).

% Obtain content of the cell Row,Column 

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

% Replace value of a cell in the matrix 

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
    replaceValueList(T, Column1, Value, TSub).


% Find the position of a player in the matrix

getPlayerPosRow(GameState, List, Row, Column, Player, ListOfPositions,Size) :-
    getPlayerPosRow(GameState, List, Row, Column, Player, [], ListOfPositions,Size).

getPlayerPosRow(_, [], _, Size,_, ListOfPositions, ListOfPositions,Size).

getPlayerPosRow(GameState, [_|T], Row, Column, Player, Moves, ListOfPositions,Size) :-
    (
        checkValueMatrix(GameState, Row, Column, Content),
        Content == Player,
        appendList(Moves, [Row, Column], Res),
        Next is Column + 1,
        getPlayerPosRow(GameState, T, Row, Next, Player, Res, ListOfPositions,Size)
    );
    (
        Next is Column + 1,
        getPlayerPosRow(GameState, T, Row, Next, Player, Moves, ListOfPositions,Size)
    ).

getPlayerPos(GameState, Player, ListOfPositions,Size) :-
    getPlayerPos(GameState, GameState, Player, 0, [], ListOfPositions,Size).

getPlayerPos(_, [], _, Size, ListOfPositions, ListOfPositions,Size).

getPlayerPos(GameState, [H|T], Player, Row, ListInt, ListOfPositions,Size) :-
    getPlayerPosRow(GameState, H, Row, 0, Player, List,Size),
    append(ListInt, List, Res),
    Next is Row + 1,
    getPlayerPos(GameState, T, Player, Next, Res, ListOfPositions,Size).

copyMatrix(Init, Final) :- accCp(Init, Final).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1, T2).

appendList(L1, [], L1).

appendList(L1, L2, L) :-
    append(L1, [L2], L).

appendMoves(_, [], []).
appendMoves(Pos, Moves, Ret):-
  append(Pos, Moves, Ret).