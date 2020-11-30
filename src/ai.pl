
% Obtaining possible game moves

valid_moves(GameState, Player, ListOfMoves, Size) :-
    getPlayerPos(GameState, Player, ListOfPositions,Size),
    getAllPossibleMoves(GameState, Player, ListOfPositions, ListOfMoves, Size).

% Random algorithm to chose move

choose_move(GameState, Player, Level, Move, Size) :-
    Level == 'random',
    valid_moves(GameState, Player, ListOfMoves, Size),
    random(0, 2, RedFish), /*choosing randomly between fishes*/
    nth0(RedFish, ListOfMoves, X),
    [InitRow, InitColumn | Moves] = X,
    random_member([FinalRow,FinalColumn], Moves), /*random move*/
    Move = [[InitRow, InitColumn], [FinalRow, FinalColumn]].

% Greedy algorithm to chose move

choose_move(GameState, Player, Level, Move, Size) :-
    Level == 'greedy',
    valid_moves(GameState, Player, ListOfMoves, Size),
    nth0(0, ListOfMoves, Fish1),
    nth0(1, ListOfMoves, Fish2),
    Fish1 = [InitRow1, InitColumn1 | Moves1],
    Fish2 = [InitRow2, InitColumn2 | Moves2],
    length(Moves1,Len1),
    length(Moves2,Len2),
    print(Len1),print(Len2),
    Len1>0,Len2>0,
    getMovesValuesBot(GameState, Player, Moves1, [InitRow1, InitColumn1], FinalPos1, Value1, Size), % obtaining value of final position for each fish
    getMovesValuesBot(GameState, Player, Moves2, [InitRow2, InitColumn2], FinalPos2, Value2, Size),
    selectBestMove(Value1, Value2, [[InitRow1, InitColumn1], FinalPos1], [[InitRow2, InitColumn2], FinalPos2], Move).
    
    
getMovesValuesBot(GameState, Player, ListOfValidMoves, InitPos, FinalPos, Value, Size) :-
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
            value(NewGameState1, Player, FinalRow, FinalColumn, Value1, Size),
            InitPos1 = [InitRow, InitColumn],
            FinalPos1 = [FinalRow, FinalColumn]
        ),
        Results
    ),
    sort(Results, SortedResults),
    reverse(SortedResults, [Value-InitPos-FinalPos-_ | _]).

value(GameState, Player, FinalRow, FinalCol, Value, Size) :-
    getAdjacentes(GameState, FinalRow, FinalCol, Adj, Size),
    calculateScore(GameState, Adj, 0, Score),
    Value = Score, !.

selectBestMove(Value1, Value2, Move1, Move2, FinalMove) :-
    Value1 > Value2,
    FinalMove = Move1.

selectBestMove(Value1, Value2, Move1, Move2, FinalMove) :-
    Value2 > Value1,
    FinalMove = Move2.

selectBestMove(Value1, Value2, Move1, Move2, FinalMove) :-
    random(0, 2, X),
    chooseRandomMove(X, Move1, Move2, FinalMove).

chooseRandomMove(X, Move1, Move2, Move1) :-
    X == 0.

chooseRandomMove(X, Move1, Move2, Move2) :-
    X == 1.


% Random algorithm to chose stone spot

choose_stone(MidGameState, FinalGameState, Player, Level, Size) :-
    Level == 'random',
    random(0, Size, Row),
    random(0, Size, Col),
    checkValueMatrix(MidGameState, Row, Col, Content),
    checkStone(MidGameState, Row, Col, Content, FinalGameState, Level, Size).

% Greedy algorithm to chose stone spot

choose_stone(MidGameState, FinalGameState,Player, Level, Size) :-
    Level == 'greedy', % colocar stone no move que mais pontos dará ao adversário
    choose_move(MidGameState, Player, Level, Move, Size),
    Move = [InitPos, FinalPos],
    FinalPos = [Row, Col],
    checkValueMatrix(MidGameState, Row, Col, Content),
    checkStone(MidGameState, Row, Col, Content, FinalGameState, Level, Size).

% Evaluating stone spot chosen

checkStone(MidGameState, Row, Col, Content,FinalGameState,_Level, Size):-
    Content == empty,
    replaceValueMatrix(MidGameState, Row, Col, stone, FinalGameState),
    format('\nPut stone in row ~d and column ~d\n', [Row, Col]).

checkStone(MidGameState, Row, Col,Content,FinalGameState,Level, Size):-
    choose_stone(MidGameState,FinalGameState,Player,Level, Size).
