decideMove(Adj, GameState, MidGameState, FinalRow, FinalCol):-
    Player = red,
    random_member((FinalRow,FinalCol),Adj),
    /*setof(X, member(X,Adj), Moves),
    (FinalRow,FinalCol) is Moves[0],*/
    checkValueMatrix(GameState, FinalRow, FinalCol, Content),
    checkMove(GameState, FinalRow, FinalCol, Player, Content,Adj,MidGameState).

checkMove(GameState, FinalRow, FinalCol, Player, Content,_Adj,MidGameState):-
    Content==empty, 
    sleep(1),
    replaceValueMatrix(GameState, FinalRow, FinalCol, red, MidGameState),
    sleep(1).

checkMove(GameState, FinalRow, FinalCol, Player, MidGameState, Content,Adj,MidGameState):-
    decideMove(Adj, GameState, MidGameState).
     
decideStone(MidGameState,FinalGameState):-
    random(0,6,Row),
    random(0,6,Col),
    checkValueMatrix(MidGameState, Row, Col, Content),
    checkStone(MidGameState, Row, Col, Content,FinalGameState).

checkStone(MidGameState, Row, Col, Content,FinalGameState):-
    Content==empty,
    sleep(1),
    replaceValueMatrix(MidGameState, Row, Col, stone, FinalGameState),
    sleep(1).

checkStone(GameState, Row, Col,Content,MidGameState):-
    decideStone(MidGameState,FinalGameState).

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
    