decideMove(Adj, GameState, MidGameState, FinalRow, FinalCol):-
    Player = red,
    [H,H2|T]=Adj,
    random_member([FinalRow,FinalCol], T),
    /*setof(X, member(X,Adj), Moves),
    (FinalRow,FinalCol) is Moves[0],*/
    checkValueMatrix(GameState, FinalRow, FinalCol, Content),
    checkMove(GameState, FinalRow, FinalCol, Player, Content,T,MidGameState).

checkMove(GameState, FinalRow, FinalCol, Player, Content,_Adj,MidGameState):-
    Content==empty, 
    sleep(1),
    replaceValueMatrix(GameState, FinalRow, FinalCol, red, MidGameState),
    sleep(1).

checkMove(GameState, FinalRow, FinalCol, Player, MidGameState, Content,Adj,MidGameState):-
    decideMove(Adj, GameState, MidGameState).
     
decideStone(MidGameState,FinalGameState):-
    random(0,7,Row),
    random(0,7,Col),
    checkValueMatrix(MidGameState, Row, Col, Content),
    checkStone(MidGameState, Row, Col, Content, FinalGameState).

checkStone(MidGameState, Row, Col, Content,FinalGameState):-
    Content == empty,
    sleep(1),
    replaceValueMatrix(MidGameState, Row, Col, stone, FinalGameState),
    format('\nPut stone in row ~d and column ~d\n', [Row, Col]),
    sleep(1).

checkStone(GameState, Row, Col,Content,MidGameState):-
    decideStone(MidGameState,FinalGameState).

choose_move(GameState, Player, Level, Move) :-
    Level == 'random',
    valid_moves(GameState, Player, ListOfMoves),
    random(0, 2, RedFish), /*choosing randomly between red fishes*/
    nth0(RedFish, ListOfMoves, X),
    [InitRow, InitColumn | Moves] = X,
    random_member([FinalRow,FinalColumn], Moves),
    Move = [[InitRow, InitColumn], [FinalRow, FinalColumn]].


choose_move(GameState, Player, Level, Move) :-
    Level == 'greedy',
    valid_moves(GameState, Player, ListOfMoves),
    nth0(0, ListOfMoves, Fish1),
    nth0(1, ListOfMoves, Fish2),
    Fish1 = [InitRow1, InitColumn1 | Moves1],
    Fish2 = [InitRow2, InitColumn2 | Moves2],
    getMovesValuesBot(GameState, Player, Moves1, [InitRow1, InitColumn1], FinalPos1, Value1),
    getMovesValuesBot(GameState, Player, Moves2, [InitRow2, InitColumn2], FinalPos2, Value2),
    write('Final Pos1: '), write(FinalPos1), nl,
    write('Final Pos2: '), write(FinalPos2), nl,
    write('Value 1: '), write(Value1), nl,
    write('Value 2: '), write(Value2), nl,
    (
        Value1 >= Value2,
        Move = [[InitRow1, InitColumn1], FinalPos1]
    );
    (
        Move = [[InitRow2, InitColumn2], FinalPos2]
    ).
    
getMovesValuesBot(GameState, Player, ListOfValidMoves, InitPos, FinalPos, Value) :-
    findall(
        Value1-InitPos1-FinalPos1-Index1,
        (
            nth0(Index1, ListOfValidMoves, Move),
            nth0(0, InitPos, InitRow),
            nth0(1, InitPos, InitColumn),
            nth0(0, Move, FinalRow),
            nth0(1, Move, FinalColumn),
            replaceValueMatrix(GameState, InitRow, InitColumn, empty, NewGameState),
            replaceValueMatrix(NewGameState, FinalRow, FinalColumn, Player, NewGameState1),
            value(NewGameState1, Player, FinalRow, FinalColumn, Value1),
            InitPos1 = [InitRow, InitColumn],
            FinalPos1 = [FinalRow, FinalColumn]
        ),
        Results
    ),
    sort(Results, SortedResults),
    reverse(SortedResults, [Value-InitPos-FinalPos-_ | _]).

value(GameState, Player, FinalRow, FinalCol, Value) :-
    getAdjacentes(GameState, FinalRow, FinalCol, Adj),
    calculateScore(GameState, Adj, 0, Score),
    Value = Score,!.

/*

selectBestMoves(_,BMList,[],BestMoves):- BestMoves = BMList.

selectBestMoves(BMPoints, BMList, [H|T], BestMoves):-
    nth1(3,H,Points),
    nth1(1,H,FRow),
    nth1(2,H,FCol),
    (
        BMPoints < Points -> selectBestMoves(Points, [H] ,T, BestMoves);
        (
            (
                BMPoints =:= Points -> (append(BMList, [H], NewBMList), selectBestMoves(BMPoints, NewBMList, T, BestMoves)); 
                selectBestMoves(BMPoints, BMList, T, BestMoves)
            )
        )
    ).


findBestMove(Player, Board, BMRow, BMCol):-
    findall([CRow, CCol, NewBoard], testMove(Player, CRow, CCol, Board, NewBoard), MoveList),
    iterateMoveList(MoveList, [], Player, EvalMatrix),
    nl, write(EvalMatrix), nl,
    selectBestMoves(-200, [], EvalMatrix, BestMoves),
    length(BestMoves, MaxIndex),
    random(0,MaxIndex, Index),
    nth0(Index, BestMoves, Move),
    nth0(0,Move,BMRow),
    nth0(1,Move,BMCol),
    indexToCol(BMCol, ColString), write('PC played move '), write(ColString), write(BMRow),nl.*/
    