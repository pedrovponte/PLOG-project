selectPiece(GameState, Player, MidGameState):-
    write('Choose a piece:\n'),
    readColumn(Column),
    checkColumn(Column, InitColumn),
    readRow(Row),
    checkRow(Row, InitRow),
    validateContent(Player, GameState, InitRow, InitColumn, FinalRow, FinalCol),
    replaceValueMatrix(GameState, FinalRow, FinalCol, empty, FirstGameState),
    selectSpot(FirstGameState, Player, MidGameState, FinalRow, FinalCol).

selectSpot(GameState, Player, MidGameState, InitRow, InitColumn) :-
    write('Move to:\n'),
    readColumn(Column),
    checkColumn(Column, NewColumn),
    readRow(Row),
    checkRow(Row, NewRow),
    validateMoveRow(GameState, NewRow, NewColumn, InitRow, InitColumn, FinalRow, FinalCol, Player),
    replaceValueMatrix(GameState, FinalRow, FinalCol, Player, MidGameState).

selectSpotStone(GameState, Player, FinalGameState) :-
    write('Choose the spot to put one stone:\n'),
    readColumn(Column),
    checkColumn(Column, StoneColumn),
    readRow(Row),
    checkRow(Row, StoneRow),
    validateStoneSpot(GameState, StoneRow, StoneColumn, FinalStoneRow, FinalStoneColumn),
    replaceValueMatrix(GameState, FinalStoneRow, FinalStoneColumn, stone, FinalGameState).

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

% verify if the select space has a player piece
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

validateMoveRow(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelRow =:= InitRow, (SelCol =:= InitCol + 1; SelCol =:= InitCol - 1), Content == empty, FinalRow is SelRow, FinalCol is SelCol; /*same row move*/
    (
        validateMoveColumn(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player)
    ).  

validateMoveColumn(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol, (SelRow =:= InitRow + 1; SelRow =:= InitRow - 1), Content == empty, FinalRow is SelRow, FinalCol is SelCol; /*same column move*/
    (
        validateMoveDiagonalLeft(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player)
    ).

validateMoveDiagonalLeft(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol - 1, (SelRow =:= InitRow + 1; SelRow =:= InitRow - 1), Content == empty, FinalRow is SelRow, FinalCol is SelCol; /*diagonal to last column*/
    (
        validateMoveDiagonalRight(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player)
    ).

validateMoveDiagonalRight(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol + 1, (SelRow =:= InitRow + 1; SelRow =:= InitRow - 1), Content == empty, FinalRow is SelRow, FinalCol is SelCol; /*diagonal to next column*/
    (
        write('Invalid move! Choose another.\n'),
        readColumn(Column),
        checkColumn(Column, NewColumn),
        readRow(Row),
        checkRow(Row, NewRow),
        validateMoveRow(GameState, NewRow, NewColumn, InitRow, InitCol, FinalRow, FinalCol, Player)
    ).

validateStoneSpot(GameState, SelRow, SelCol, FinalRow, FinalCol) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    Content == empty, FinalRow is SelRow, FinalCol is SelCol;
    (
        write('Invalid spot! Choose another.\n'),
        readColumn(Column),
        checkColumn(Column, NewColumn),
        readRow(Row),
        checkRow(Row, NewRow),
        validateMoveRow(GameState, NewRow, NewColumn, FinalRow, FinalCol)
    ).