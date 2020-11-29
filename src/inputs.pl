% Asking the player to chose the piece he wants to move
selectPiece(GameState, Player, MidGameState, Move, Jump, Size) :-
    write('Choose a piece:\n'),
    readColumn(Column, Size),
    checkColumn(Column, InitColumn),
    readRow(Row, Size),
    checkRow(Row, InitRow),
    validateContent(Player, GameState, InitRow, InitColumn, FinalRow, FinalCol),
    replaceValueMatrix(GameState, FinalRow, FinalCol, empty, FirstGameState),
    append([], [FinalRow, FinalCol], MidMove),
    selectSpot(FirstGameState, Player, MidGameState, FinalRow, FinalCol, NewRow, NewColumn, Jump, Size),
    append(MidMove, [NewRow, NewColumn], Move).

% Asking the player to chose a place where he wants to move
selectSpot(GameState, Player, MidGameState, InitRow, InitColumn, NewRow, NewColumn, Jump, Size) :-
    write('Move to:\n'),
    readColumn(Column, Size),
    checkColumn(Column, NewColumn),
    readRow(Row, Size),
    checkRow(Row, NewRow),
    validateMove(GameState, NewRow, NewColumn, InitRow, InitColumn,FinalRow,FinalCol ,Player, Jump),
    replaceValueMatrix(GameState, FinalRow, FinalCol, Player, MidGameState).

% Asking the player to chose a place for the stone

selectSpotStone(GameState, Player, FinalGameState) :-
    write('Choose a spot to put one stone:\n'),
    readColumn(Column),
    checkColumn(Column, StoneColumn),
    readRow(Row),
    checkRow(Row, StoneRow),
    write('hello1\n'), nl,
    validateStoneSpot(GameState, StoneRow, StoneColumn, FinalStoneRow, FinalStoneColumn),
    write('hello2\n'), nl,
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
    readRow(Row).

readRow(Row, Size) :-
    write('Choose a row: '),
    readRow(Row).

% check if introduced column is valid
checkColumn(0, 0).
checkColumn(1, 1).
checkColumn(2, 2).
checkColumn(3, 3).
checkColumn(4, 4).
checkColumn(5, 5).
checkColumn(6, 6).
checkColumn(7, 7).
checkColumn(8, 8).
checkColumn(9, 9).
checkColumn(10, 10).

% If not, asks for a new column
checkColumn(_Column, InitColumn):-
    write('Invalid column\nSelect again\n'),
    readColumn(Column),
    checkColumn(Column, InitColumn).

% Check if introduced row is valid
checkRow('A', 0).
checkRow('B', 1).
checkRow('C', 2).
checkRow('D', 3).
checkRow('E', 4).
checkRow('F', 5).
checkRow('G', 6).
checkRow('H', 7).
checkRow('I', 8).
checkRow('J', 9).
checkRow('a', 0).
checkRow('b', 1).
checkRow('c', 2).
checkRow('d', 3).
checkRow('e', 4).
checkRow('f', 5).
checkRow('g', 6).
checkRow('h', 7).
checkRow('i', 8).
checkRow('j', 9).

% If not, asks for a new row

checkRow(_Row, InitRow) :-
    write('Invalid row\nSelect again\n'),
    readRow(NewRow),
    checkRow(NewRow, InitRow).

% Verify if the select space has a player piece

validateContent(Player, GameState, InitRow, InitColumn, FinalRow, FinalCol) :-
    checkValueMatrix(GameState, InitRow, InitColumn, Content),
    Player == Content, FinalRow is InitRow, FinalCol is InitColumn;
    (
        write('Invalid Piece! Choose one of yours\n'),
        write('Choose a piece:\n'),
        readColumn(Column),
        checkColumn(Column, NewColumn),
        readRow(Row),
        checkRow(Row, NewRow),
        validateContent(Player, GameState, NewRow, NewColumn, FinalRow, FinalCol)
    ).

% Verify if the player can move to the chosen place

validateMove(GameState, SelR, SelC, InitRow, InitCol, FinalRow,FinalCol,Player, Jump) :-
    getMoves(GameState, InitRow, InitCol, ListOfMoves),
    member([SelR,SelC],ListOfMoves),FinalRow is SelR , FinalCol is SelC,checkJump(InitRow, InitCol, SelR, SelC, Jump);
    (
        write('Invalid Move! Choose another...\n'),
        readColumn(Column),
        checkColumn(Column, NewColumn),
        readRow(Row),
        checkRow(Row, NewRow),
        validateMove(GameState, NewRow, NewColumn, InitRow, InitCol,FinalRow,FinalCol, Player, Jump)
    ).

% Validating if stone spot is empty

validateStoneSpot(GameState, SelRow, SelCol, FinalRow, FinalCol) :-
    write('hello3\n'), nl,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    write('hello4\n'), nl, write(SelRow), write(SelCol), write(Content), nl,
    Content == empty, FinalRow is SelRow, FinalCol is SelCol;
    (
        write('Invalid spot! Choose another.\n'),
        readColumn(Column),
        checkColumn(Column, NewColumn),
        readRow(Row),
        checkRow(Row, NewRow),
        validateStoneSpot(GameState, NewRow, NewColumn, FinalRow, FinalCol)
    ).
