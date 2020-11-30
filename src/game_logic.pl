% Calculating Score based on the game state

calculateScore(_GameState,[],Score,Score).

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

% Obtaining list of adjacent cels to the position Row,Col

getAdjacentes(GameState, Row, Col, Adj, Size):-
    RealSize is Size - 1,
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    appendList([],[Row1,Col], List),
    appendList(List,[Row2,Col], List1),
    appendList(List1,[Row1,Col1], List2),
    appendList(List2,[Row2,Col1], List3),
    appendList(List3,[Row,Col1], List4),
    appendList(List4,[Row1,Col2], List5),
    appendList(List5,[Row2,Col2], List6),
    appendList(List6,[Row,Col2], List7),
    findall([R,C], 
            (
                member([R,C], List7),
                R >= 0, R =< RealSize,
                C >= 0, C =< RealSize
            ), 
            Adj).

% Checking if the player can add a stone to the bord: has stones left && didn't jump

canPutStone(NumStones,MidGameState,Player,FinalGameState,NumStonesFinal, Jump, _, _):-
	(NumStones =:= 0; Jump =:= 1),
	NumStonesFinal is NumStones,
	copyMatrix(MidGameState, FinalGameState),
    write('No stone played\n').

canPutStone(NumStones,MidGameState,Player,FinalGameState, NumStonesFinal, Jump, Mode, Size):-
	Player == computer,
	choose_stone(MidGameState, FinalGameState, yellow, Mode, Size),
	NumStonesFinal is NumStones - 1.

canPutStone(NumStones,MidGameState,Player,FinalGameState, NumStonesFinal, Jump, Mode, Size):-
	Player == computer1,
	choose_stone(MidGameState, FinalGameState, red, Mode, Size),
	NumStonesFinal is NumStones - 1.

canPutStone(NumStones,MidGameState,Player,FinalGameState, NumStonesFinal, Jump, Mode, Size):-
	Player == computer2,
	choose_stone(MidGameState, FinalGameState, yellow, Mode, Size),
	NumStonesFinal is NumStones - 1.

canPutStone(NumStones,MidGameState,Player,FinalGameState, NumStonesFinal, Jump, _, Size):-
	selectSpotStone(MidGameState, Player, FinalGameState, Size),
	NumStonesFinal is NumStones - 1.


% Checking end of the game

% Evaluation about the end of the game
game_over(GameState, Winner, Player, NextPlayer, FinalScore, Score1, Score2) :-
	checkGameOver(Player, NextPlayer,  FinalScore),
	NextPlayer == end, 
	!,
	Winner == Player.

checkGameOver(_Player,NextPlayer,Score):-
	Score >= 10,
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


% Checking if the player jumped over a stone (Jump=1) or not (Jump=0)

checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump) :-
	FinalRow - InitRow =:= 2,
	Jump = 1.

checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump) :-
	InitRow - FinalRow =:= 2,
	Jump = 1.

checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump) :-
	FinalColumn - InitColumn =:= 2,
	Jump = 1.

checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump) :-
	InitColumn - FinalColumn =:= 2,
	Jump = 1.

checkJump(InitRow, InitColumn, FinalRow, FinalColumn, Jump) :-
	Jump = 0.
    
% Auxiliar functions to get all possible moves 

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


getAllPossibleMoves(GameState, Player, ListOfPositions, ListOfMoves, Size) :-
    getAllPossibleMoves(GameState, Player, ListOfPositions, [], ListOfMoves, Size).

getAllPossibleMoves(_, _, [], ListOfMoves, ListOfMoves, Size).

getAllPossibleMoves(GameState, Player, [H|T], ListInt, ListOfMoves, Size) :-
    parsePos(H, InitRow, InitColumn),
    getMoves(GameState, InitRow, InitColumn, Moves, Size),
    cleanInvalidMoves(GameState, Moves, [], FinalMoves),
    appendMoves(H, FinalMoves, ListAux),
    appendList(ListInt, ListAux, ListNew),
    getAllPossibleMoves(GameState, Player, T, ListNew, ListOfMoves, Size).

getMoves(GameState, InitRow, InitColumn, ListOfMoves, Size) :-
    getAdjacentes(GameState, InitRow, InitColumn, ListInt, Size),
    getPossibleJumps(GameState, InitRow, InitColumn, ListInt, [], ListRes),
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
        getPossibleJumps(GameState, InitRow, InitColumn, T, ListNew, ListRes),
        append(ListAux, ListInt, ListNew)
        
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



    
