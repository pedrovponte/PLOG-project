/*Score*/
calculateScore(_GameState,[],Score1,Score1).

calculateScore(GameState,[[H,H2]|T],Score, ScorePlus):-
    check(GameState,H,H2,Score,Score1),
    calculateScore(GameState,T,Score1,ScorePlus).

increment(Content,Score,ScorePlus):-
    (Content == empty; Content == stone),
    ScorePlus is Score.

increment(Content,Score,ScorePlus):-
    ScorePlus is Score + 1.


check(GameState, Row, Col, Score, Plus):-
    checkValueMatrix(GameState, Row, Col, Content),
    increment(Content,Score,Plus).

/*9 casos diferentes de posições no board*/
getAdjacentes(GameState,Row,Col,Adj):-
    Row==0, Col==0, 
    appendList([],[1,0], Adj1),
    appendList(Adj1,[0,1], Adj2),
    appendList(Adj2,[1,1], Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==6, Col==0, 
    appendList([],[5,0],Adj1),
    appendList(Adj1,[5,1], Adj2),
    appendList(Adj2,[6,1], Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==0, Col==6, 
    appendList([],[0,5], Adj1),
    appendList(Adj1,[1,6], Adj2),
    appendList(Adj2,[1,5], Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==6, Col==6, 
    appendList([],[5,5], Adj1),
    appendList(Adj1,[6,5], Adj2),
    appendList(Adj2,[5,6], Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==0,
    Row1 is Row+1,
    Col1 is Col+1,
    Col2 is Col-1,
    appendList([],[Row1,Col], Adj1),
    appendList(Adj1,[Row,Col2], Adj2),
    appendList(Adj2,[Row,Col1], Adj3),
    appendList(Adj3,[Row1,Col1], Adj4),
    appendList(Adj4,[Row1,Col2], Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==6,
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    appendList([],[Row2,Col], Adj1),
    appendList(Adj1,[Row,Col2], Adj2),
    appendList(Adj2,[Row,Col1], Adj3),
    appendList(Adj3,[Row2,Col1], Adj4),
    appendList(Adj4,[Row2,Col2], Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Col==0,
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    appendList(Adj,[Row1,Col], Adj1),
    appendList(Adj1,[Row2,Col], Adj2),
    appendList(Adj2,[Row1,Col1], Adj3),
    appendList(Adj3,[Row,Col1], Adj4),
    appendList(Adj4,[Row2,Col1], Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Col==6,
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    appendList([],[Row1,Col], Adj1),
    appendList(Adj1,[Row2,Col], Adj2),
    appendList(Adj2,[Row1,Col2], Adj3),
    appendList(Adj3,[Row,Col2], Adj4),
    appendList(Adj4,[Row2,Col2], Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    appendList([],[Row1,Col], Adj1),
    appendList(Adj1,[Row2,Col], Adj2),
    appendList(Adj2,[Row1,Col1], Adj3),
    appendList(Adj3,[Row2,Col1], Adj4),
    appendList(Adj4,[Row,Col1], Adj5),
    appendList(Adj5,[Row1,Col2], Adj6),
    appendList(Adj6,[Row2,Col2], Adj7),
    appendList(Adj7,[Row,Col2], Adj).

/*End Game*/
checkGameOver(_Player,NextPlayer,Score):-
	Score==10,
	NextPlayer = end.

checkGameOver(Player,NextPlayer,_Score):-
	NextPlayer = Player.

endGame(YellowScore,RedScore):-
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),
	write('GAME ENDED\n'),
    YellowScore > RedScore,
    write('Yellow player wins the game!\n');
    (
        write('Red player wins the game!\n')
    ).

parsePos([Row, Column | _], Row, Column).

parseMoves([Moves | _], Moves).

cleanInvalidMoves(_, [], ListFinal, ListFinal).

cleanInvalidMoves(GameState, [H | T], ListInt, ListFinal) :-
    parsePos(H, Row, Column),
    checkValueMatrix(GameState, Row, Column, Content),
    (
        Content == empty,
        appendList(ListInt, [Row, Column], ListNew),
        cleanInvalidMoves(GameState, T, ListNew, ListFinal)
    );
    cleanInvalidMoves(GameState, T, ListInt, ListFinal).
    

valid_moves(GameState, Player, ListOfMoves) :-
    getPlayerPos(GameState, Player, ListOfPositions),
    getAllPossibleMoves(GameState, Player, ListOfPositions, ListOfMoves).

getAllPossibleMoves(GameState, Player, ListOfPositions, ListOfMoves) :-
    getAllPossibleMoves(GameState, Player, ListOfPositions, [], ListOfMoves).

getAllPossibleMoves(_, _, [], ListOfMoves, ListOfMoves).

getAllPossibleMoves(GameState, Player, [H|T], ListInt, ListOfMoves) :-
    parsePos(H, InitRow, InitColumn),
    getMoves(GameState, InitRow, InitColumn, Moves),
    cleanInvalidMoves(GameState, Moves, [], FinalMoves),
    appendMoves(H, FinalMoves, ListAux),
    appendList(ListInt, ListAux, ListNew),
    getAllPossibleMoves(GameState, Player, T, ListNew, ListOfMoves).

getMoves(GameState, InitRow, InitColumn, ListOfMoves) :-
    getAdjacentes(GameState, InitRow, InitColumn, ListInt),
    getPossibleJumps(GameState, InitRow, InitColumn, ListInt, ListAux, ListRes),
    append(ListInt, ListRes, ListOfMoves).


getPossibleJumps(_, _, _, [], ListRes, ListRes).

getPossibleJumps(GameState, InitRow, InitColumn, [H|T], ListAux, ListRes) :-
    parsePos(H, StoneRow, StoneColumn),
    checkValueMatrix(GameState, StoneRow, StoneColumn, Content),
    (
        Content == stone,
        checkJumpLeft(GameState, InitRow, InitColumn, StoneRow, StoneColumn, LeftList),
        checkJumpRight(GameState, InitRow, InitColumn, StoneRow, StoneColumn, RightList),
        checkJumpTop(GameState, InitRow, InitColumn, StoneRow, StoneColumn, TopList),
        checkJumpDown(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DownList),
        checkJumpDiagonalLeftTop(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DiagonalLeftTopList),
        checkJumpDiagonalLeftDown(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DiagonalLeftDownList),
        checkJumpDiagonalRightTop(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DiagonalRightTopList),
        checkJumpDiagonalRightDown(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DiagonalRightDownList),
        append([LeftList], [], L1),
        append(L1, [RightList], L2),
        append(L2, [TopList], L3),
        append(L3, [DownList], L4),
        append(L4, [DiagonalLeftTopList], L5),
        append(L5, [DiagonalLeftDownList], L6),
        append(L6, [DiagonalRightTopList], L7),
        append(L7, [DiagonalRightDownList], ListInt),
        append(ListAux, ListInt, ListNew),
        getPossibleJumps(GameState, InitRow, InitColumn, T, ListNew, ListRes)
    );
    getPossibleJumps(GameState, InitRow, InitColumn, T, ListAux, ListRes).


checkJumpLeft(GameState, InitRow, InitColumn, StoneRow, StoneColumn, LeftList) :-
    StoneRow =:= InitRow,
    StoneColumn =:= InitColumn - 1,
    StoneColumn > 0,
    FinalColumn is StoneColumn - 1,
    checkValueMatrix(GameState, StoneRow, FinalColumn, Content),
    Content == empty,
    append([], [StoneRow, FinalColumn], LeftList).

checkJumpLeft(_, _, _, _, _, []).

checkJumpRight(GameState, InitRow, InitColumn, StoneRow, StoneColumn, RightList) :-
    StoneRow =:= InitRow,
    StoneColumn =:= InitColumn + 1,
    StoneColumn < 6,
    FinalColumn is StoneColumn + 1,
    checkValueMatrix(GameState, StoneRow, FinalColumn, Content),
    Content == empty,
    append([], [StoneRow, FinalColumn], RightList).

checkJumpRight(_, _, _, _, _, []).

checkJumpTop(GameState, InitRow, InitColumn, StoneRow, StoneColumn, TopList) :-
    StoneColumn =:= InitColumn,
    StoneRow =:= StoneRow - 1,
    StoneRow > 0,
    FinalRow is StoneRow - 1,
    checkValueMatrix(GameState, StoneRow - 1, StoneColumn, Content),
    Content == empty,
    append([], [FinalRow, StoneColumn], TopList).

checkJumpTop(_, _, _, _, _, []).

checkJumpDown(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DownList) :-
    StoneColumn =:= InitColumn,
    StoneRow =:= StoneRow + 1,
    StoneRow < 6,
    FinalRow is StoneRow + 1,
    checkValueMatrix(GameState, FinalRow, StoneColumn, Content),
    Content == empty,
    append([], [FinalRow, StoneColumn], DownList).

checkJumpDown(_, _, _, _, _, []).

checkJumpDiagonalLeftTop(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DiagonalLeftTopList) :-
    InitRow >= 2,
    InitColumn >= 2,
    StoneRow =:= InitRow - 1,
    StoneColumn =:= InitColumn -1,
    FinalRow is StoneRow - 1,
    FinalColumn is StoneColumn - 1,
    checkValueMatrix(GameState, FinalRow, FinalColumn, Content),
    Content == empty,
    append([], [FinalRow, FinalColumn], DiagonalLeftTopList).

checkJumpDiagonalLeftTop(_, _, _, _, _, []).

checkJumpDiagonalLeftDown(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DiagonalLeftDownList) :-
    InitRow =< 4,
    InitColumn >= 2,
    StoneRow =:= InitRow + 1,
    StoneColumn =:= InitColumn - 1,
    FinalRow is StoneRow + 1,
    FinalColumn is StoneColumn - 1,
    checkValueMatrix(GameState, FinalRow, FinalColumn, Content),
    Content == empty,
    append([], [FinalRow, FinalColumn], DiagonalLeftDownList).

checkJumpDiagonalLeftDown(_, _, _, _, _, []).

checkJumpDiagonalRightTop(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DiagonalRightTopList) :-
    InitRow >= 2,
    InitColumn =< 4,
    StoneRow =:= InitRow - 1,
    StoneColumn =:= InitColumn + 1,
    FinalRow is StoneRow - 1,
    FinalColumn is StoneColumn + 1,
    checkValueMatrix(GameState, StoneRow - 1, StoneColumn + 1, Content),
    Content == empty,
    append([], [FinalRow, FinalColumn], DiagonalRightTopList).

checkJumpDiagonalRightTop(_, _, _, _, _, []).

checkJumpDiagonalRightDown(GameState, InitRow, InitColumn, StoneRow, StoneColumn, DiagonalRightDownList) :-
    InitRow =< 4,
    InitColumn =< 4,
    StoneRow =:= InitRow + 1,
    StoneColumn =:=  InitColumn + 1,
    FinalRow is StoneRow + 1,
    FinalColumn is StoneColumn + 1,
    checkValueMatrix(GameState, FinalRow, FinalColumn, Content),
    Content == empty,
    append([], [FinalRow, FinalColumn], DiagonalRightDownList).

checkJumpDiagonalRightDown(_, _, _, _, _, []).



    
