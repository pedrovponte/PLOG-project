selectPiece(GameState, Player, FinalGameState):-
    readColumn(Column),
    checkColumn(Column, InitColumn),
    readRow(Row),
    checkRow(Row, InitRow),
    validateContent(Player, GameState, InitRow, InitColumn),
    replaceValueMatrix(GameState, InitRow, InitColumn, empty, MidGameState),
    selectSpot(MidGameState, Player, FinalGameState, InitRow, InitColumn).

selectSpot(GameState, Player, FinalGameState, InitRow, InitColumn) :-
    readColumn(Column),
    checkColumn(Column, NewColumn),
    readRow(Row),
    checkRow(Row, NewRow).

% read column from user
readColumn(Column):-
    write('Choose a column (0 - 6): '),
    read(Column).

% read row from user 
readRow(Row):-
    write('Choose a row (A - G): '),
    read(Row).

% check if introduced column is valid
checkColumn(0, 0).
checkColumn(1, 1).
checkColumn(2, 2).
checkColumn(3, 3).
checkColumn(4, 4).
checkColumn(5, 5).
checkColumn(6, 6).

% case not, asks for a new column
checkColumn(_Column, InitColumn):-
    write('Invalid column\nSelect again\n'),
    readColumn(Column),
    checkColumn(Column, InitColumn).

% check if introduced row is valid
checkRow('A', 0).
checkRow('B', 1).
checkRow('C', 2).
checkRow('D', 3).
checkRow('E', 4).
checkRow('F', 5).
checkRow('G', 6).

% case not, asks for a new row
checkRow(_Row, InitRow) :-
    write('Invalid row\nSelect again\n'),
    readRow(NewRow),
    checkRow(NewRow, InitRow).

validateContent(Player, GameState, InitRow, InitColumn) :-
    checkValueMatrix(GameState, InitRow, InitColumn, Content),
    (Player == Content);
    (
        write('Invalid Piece! Choose one of yours\n'),
        selectPiece(GameState, Player, FinalGameState)
    ).
