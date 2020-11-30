% Move validation and execution, obtaining the new game state 
% Asking the player to chose the piece he wants to move
move(GameState, Move, MidGameState, Player, Jump, Size):-
    write('Choose a piece:\n'),
    readColumn(Column, Size),
    checkColumn(Column, InitColumn, Size),
    readRow(Row, Size),
    checkRow(Row, InitRow, Size),
    validateContent(Player, GameState, InitRow, InitColumn, FinalRow, FinalCol, Size),
    replaceValueMatrix(GameState, FinalRow, FinalCol, empty, FirstGameState),
    append([], [FinalRow, FinalCol], MidMove),
    selectSpot(FirstGameState, Player, MidGameState, FinalRow, FinalCol, NewRow, NewColumn, Jump, Size),
    append(MidMove, [NewRow, NewColumn], Move).

% Asking the player to chose a place where he wants to move
selectSpot(GameState, Player, MidGameState, InitRow, InitColumn, NewRow, NewColumn, Jump, Size) :-
    write('Move to:\n'),
    readColumn(Column, Size),
    checkColumn(Column, NewColumn, Size),
    readRow(Row, Size),
    checkRow(Row, NewRow, Size),
    validateMove(GameState, NewRow, NewColumn, InitRow, InitColumn, FinalRow, FinalCol, Player, Jump, Size),
    replaceValueMatrix(GameState, FinalRow, FinalCol, Player, MidGameState).

% Asking the player to chose a place for the stone

selectSpotStone(GameState, Player, FinalGameState, Size) :-
    write('Choose a spot to put one stone:\n'),
    readColumn(Column, Size),
    checkColumn(Column, StoneColumn, Size),
    readRow(Row, Size),
    checkRow(Row, StoneRow, Size),
    validateStoneSpot(GameState, StoneRow, StoneColumn, FinalStoneRow, FinalStoneColumn, Size),
    replaceValueMatrix(GameState, FinalStoneRow, FinalStoneColumn, stone, FinalGameState).

% Read column from user
readColumn(Column, Size):-
    format('Choose a column (0 - ~d): ', Size),
    read(Column).

% read row from user 
readRow(Row, Size):-
    Size =:= 7,
    write('Choose a row (A - G): '),
    read(Row).

readRow(Row, Size) :-
    Size =:= 9,
    write('Choose a row (A - I): '),
    read(Row).

% check if introduced column is valid
checkColumn(0, 0, _).
checkColumn(1, 1, _).
checkColumn(2, 2, _).
checkColumn(3, 3, _).
checkColumn(4, 4, _).
checkColumn(5, 5, _).
checkColumn(6, 6, _).
checkColumn(7, 7, _).
checkColumn(8, 8, _).
checkColumn(9, 9, _).
checkColumn(10, 10, _).

% If not, asks for a new column
checkColumn(_Column, InitColumn, Size):-
    write('Invalid column\nSelect again\n'),
    readColumn(Column, Size),
    checkColumn(Column, InitColumn, Size).

% Check if introduced row is valid
checkRow('A', 0, _).
checkRow('B', 1, _).
checkRow('C', 2, _).
checkRow('D', 3, _).
checkRow('E', 4, _).
checkRow('F', 5, _).
checkRow('G', 6, _).
checkRow('H', 7, _).
checkRow('I', 8, _).
checkRow('J', 9, _).
checkRow('a', 0, _).
checkRow('b', 1, _).
checkRow('c', 2, _).
checkRow('d', 3, _).
checkRow('e', 4, _).
checkRow('f', 5, _).
checkRow('g', 6, _).
checkRow('h', 7, _).
checkRow('i', 8, _).
checkRow('j', 9, _).

% If not, asks for a new row

checkRow(_Row, InitRow, Size) :-
    write('Invalid row\nSelect again\n'),
    readRow(NewRow, Size),
    checkRow(NewRow, InitRow, Size).

% Verify if the select space has a player piece

validateContent(Player, GameState, InitRow, InitColumn, FinalRow, FinalCol, Size) :-
    checkValueMatrix(GameState, InitRow, InitColumn, Content),
    Player == Content, FinalRow is InitRow, FinalCol is InitColumn;
    (
        write('Invalid Piece! Choose one of yours\n'),
        write('Choose a piece:\n'),
        readColumn(Column, Size),
        checkColumn(Column, NewColumn, Size),
        readRow(Row, Size),
        checkRow(Row, NewRow, Size),
        validateContent(Player, GameState, NewRow, NewColumn, FinalRow, FinalCol, Size)
    ).

% Verify if the player can move to the chosen place

validateMove(GameState, SelR, SelC, InitRow, InitCol, FinalRow,FinalCol,Player, Jump, Size) :-
    getMoves(GameState, InitRow, InitCol, ListOfMoves, Size),
    member([SelR,SelC],ListOfMoves), 
    FinalRow is SelR, 
    FinalCol is SelC,
    checkJump(InitRow, InitCol, SelR, SelC, Jump);
    (
        write('Invalid Move! Choose another...\n'),
        readColumn(Column, Size),
        checkColumn(Column, NewColumn, Size),
        readRow(Row, Size),
        checkRow(Row, NewRow, Size),
        validateMove(GameState, NewRow, NewColumn, InitRow, InitCol,FinalRow,FinalCol, Player, Jump, Size)
    ).

% Validating if stone spot is empty

validateStoneSpot(GameState, SelRow, SelCol, FinalRow, FinalCol, Size) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    Content == empty, 
    FinalRow is SelRow, 
    FinalCol is SelCol;
    (
        write('Invalid spot! Choose another.\n'),
        readColumn(Column, Size),
        checkColumn(Column, NewColumn, Size),
        readRow(Row, Size),
        checkRow(Row, NewRow, Size),
        validateStoneSpot(GameState, NewRow, NewColumn, FinalRow, FinalCol, Size)
    ).
