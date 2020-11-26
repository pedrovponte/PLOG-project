decideMove(Adj, GameState, MidGameState, FinalRow, FinalCol):-
    Player = red,
    [H,H2|T]=Adj,
    random_member([FinalRow,FinalCol], T),
    /*setof(X, member(X,Adj), Moves),
    (FinalRow,FinalCol) is Moves[0],*/
    checkValueMatrix(GameState, FinalRow, FinalCol, Content),
    checkMove(GameState, FinalRow, FinalCol, Player, Content,Adj,MidGameState).

checkMove(GameState, FinalRow, FinalCol, Player, Content,_Adj,MidGameState):-
    Content==empty, 
    replaceValueMatrix(GameState, FinalRow, FinalCol, red, MidGameState).

checkMove(GameState, FinalRow, FinalCol, Player, MidGameState, Content,Adj,MidGameState):-
    decideMove(Adj, GameState, MidGameState).
     


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
    selectBestMove(Value1, Value2, [[InitRow1, InitColumn1], FinalPos1], [[InitRow2, InitColumn2], FinalPos2], Move).
    
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
    Value = Score, !.

selectBestMove(Value1, Value2, Move1, Move2, FinalMove) :-
    Value1 >= Value2,
    FinalMove = Move1.

selectBestMove(Value1, Value2, Move1, Move2, FinalMove) :-
    Value2 > Value1,
    FinalMove = Move2.



choose_stone(MidGameState, FinalGameState, Level) :-
    Level == 'random',
    random(0,6,Row),
    random(0,6,Col),
    checkValueMatrix(MidGameState, Row, Col, Content),
    checkStone(MidGameState, Row, Col, Content, FinalGameState,Level).

checkStone(MidGameState, Row, Col, Content,FinalGameState,_Level):-
    Content == empty,
    replaceValueMatrix(MidGameState, Row, Col, stone, FinalGameState),
    format('\nPut stone in row ~d and column ~d\n', [Row, Col]).

checkStone(GameState, Row, Col,Content,FinalGameState,Level):-
    choose_stone(MidGameState,FinalGameState,Level).


choose_stone(MidGameState, FinalGameState, Level) :-
    Level == 'greedy',
    Player = yellow, %colocar stones nos possiveis moves do adversário
    valid_moves(MidGameState, Player, ListAdjacentes),
    nth0(0, ListAdjacentes, Fish1),
    nth0(1, ListAdjacentes, Fish2),
    Fish1 = [InitRow1, InitColumn1 | Moves1],
    Fish2 = [InitRow2, InitColumn2 | Moves2],
    append(Moves1,Moves2,TotalMoves),
    random_member([Row,Col],TotalMoves),
    checkValueMatrix(MidGameState, Row, Col, Content),
    checkStone(MidGameState, Row, Col, Content, FinalGameState,Level).

