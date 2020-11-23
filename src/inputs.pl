selectPiece(GameState, Player, MidGameState, NewRow, NewColumn, Jump):-
    write('Choose a piece:\n'),
    readColumn(Column),
    checkColumn(Column, InitColumn),
    readRow(Row),
    checkRow(Row, InitRow),
    validateContent(Player, GameState, InitRow, InitColumn, FinalRow, FinalCol),
    replaceValueMatrix(GameState, FinalRow, FinalCol, empty, FirstGameState),
    selectSpot(FirstGameState, Player, MidGameState, FinalRow, FinalCol, NewRow, NewColumn, Jump).


selectSpot(GameState, Player, MidGameState, InitRow, InitColumn, NewRow, NewColumn, Jump) :-
    write('Move to:\n'),
    readColumn(Column),
    checkColumn(Column, NewColumn),
    readRow(Row),
    checkRow(Row, NewRow),
    validateMoveRow(GameState, NewRow, NewColumn, InitRow, InitColumn, FinalRow, FinalCol, Player, Jump),
    replaceValueMatrix(GameState, FinalRow, FinalCol, Player, MidGameState).

selectSpotStone(GameState, Player, FinalGameState) :-
    write('Choose a spot to put one stone:\n'),
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
checkRow('a', 0).
checkRow('b', 1).
checkRow('c', 2).
checkRow('d', 3).
checkRow('e', 4).
checkRow('f', 5).
checkRow('g', 6).

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

validateMoveRow(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelRow =:= InitRow, 
    (SelCol =:= InitCol + 1; SelCol =:= InitCol - 1), 
    Content == empty, 
    FinalRow is SelRow, 
    FinalCol is SelCol,
    Jump is 0; /*same row move*/
    (
        validateMoveColumn(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).  

validateMoveColumn(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol, 
    (SelRow =:= InitRow + 1; SelRow =:= InitRow - 1), 
    Content == empty, 
    FinalRow is SelRow, 
    FinalCol is SelCol,
    Jump is 0; /*same column move*/
    (
        validateMoveDiagonalLeft(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateMoveDiagonalLeft(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol - 1, 
    (SelRow =:= InitRow + 1; SelRow =:= InitRow - 1), 
    Content == empty, 
    FinalRow is SelRow, 
    FinalCol is SelCol,
    Jump is 0; /*diagonal left*/
    (
        validateMoveDiagonalRight(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateMoveDiagonalRight(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol + 1, 
    (SelRow =:= InitRow + 1; SelRow =:= InitRow - 1), 
    Content == empty, 
    FinalRow is SelRow, 
    FinalCol is SelCol,
    Jump is 0; /*diagonal right*/
    (
        validateJumpRowRight(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateJumpRowRight(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    SelCol > InitCol,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelRow =:= InitRow,
    SelCol =:= InitCol + 2,
    Content == empty, 
    checkValueMatrix(GameState, SelRow, InitCol + 1, Content1),
    Content1 == stone,
    FinalRow is SelRow,
    FinalCol is SelCol,
    Jump is 1; /*jump same row right*/
    (
        validateJumpRowLeft(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateJumpRowLeft(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    SelCol < InitCol,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelRow =:= InitRow,
    SelCol =:= InitCol - 2,
    Content == empty, 
    checkValueMatrix(GameState, SelRow, InitCol - 1, Content1),
    Content1 == stone,
    FinalRow is SelRow,
    FinalCol is SelCol,
    Jump is 1; /*jump same row left*/
    (
        validateJumpColumnUp(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateJumpColumnUp(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    SelRow < InitRow,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol,
    SelRow =:= InitRow - 2,
    Content == empty,
    checkValueMatrix(GameState, InitRow - 1, SelCol, Content1),
    Content1 == stone,
    FinalRow is SelRow,
    FinalCol is SelCol,
    Jump is 1; /*jump same column*/
    (
        validateJumpColumnDown(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateJumpColumnDown(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    SelRow > InitRow,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol,
    SelRow =:= InitRow + 2,
    Content == empty,
    checkValueMatrix(GameState, InitRow + 1, SelCol, Content1),
    Content1 == stone,
    FinalRow is SelRow,
    FinalCol is SelCol,
    Jump is 1; /*jump same column*/
    (
        validateJumpDiagonalLeftUp(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateJumpDiagonalLeftUp(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    SelRow < InitRow,
    SelCol < InitCol,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol - 2,
    SelRow =:= InitRow - 2,
    Content == empty,
    checkValueMatrix(GameState, InitRow - 1, InitCol - 1, Content1),
    Content1 == stone,
    FinalRow is SelRow,
    FinalCol is SelCol,
    Jump is 1; /*jump diagonal left up*/
    (
        validateJumpDiagonalLeftDown(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateJumpDiagonalLeftDown(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    SelRow > InitRow,
    SelCol < InitCol,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol - 2,
    SelRow =:= InitRow + 2,
    Content == empty,
    checkValueMatrix(GameState, InitRow + 1, InitCol - 1, Content1),
    Content1 == stone,
    FinalRow is SelRow,
    FinalCol is SelCol,
    Jump is 1; /*jump diagonal left down*/
    (
        validateJumpDiagonalRightUp(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateJumpDiagonalRightUp(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    SelRow < InitRow,
    SelCol > InitCol,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol + 2,
    SelRow =:= InitRow - 2,
    Content == empty,
    checkValueMatrix(GameState, InitRow - 1, InitCol + 1, Content1),
    Content1 == stone,
    FinalRow is SelRow,
    FinalCol is SelCol,
    Jump is 1; /*jump diagonal right up*/
    (
        validateJumpDiagonalRightDown(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateJumpDiagonalRightDown(GameState, SelRow, SelCol, InitRow, InitCol, FinalRow, FinalCol, Player, Jump) :-
    SelRow > InitRow,
    SelCol > InitCol,
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    SelCol =:= InitCol + 2,
    SelRow =:= InitRow + 2,
    Content == empty,
    checkValueMatrix(GameState, InitRow + 1, InitCol + 1, Content1),
    Content1 == stone,
    FinalRow is SelRow,
    FinalCol is SelCol,
    Jump is 1; /*jump diagonal right down*/
    (
        write('Invalid move! Choose another.\n'),
        readColumn(Column),
        checkColumn(Column, NewColumn),
        readRow(Row),
        checkRow(Row, NewRow),
        validateMoveRow(GameState, NewRow, NewColumn, InitRow, InitCol, FinalRow, FinalCol, Player, Jump)
    ).

validateStoneSpot(GameState, SelRow, SelCol, FinalRow, FinalCol) :-
    checkValueMatrix(GameState, SelRow, SelCol, Content),
    Content == empty, write(Content == empty), write('\n'), FinalRow is SelRow, write(FinalRow), write('\n'), FinalCol is SelCol, write(FinalCol), write('\n');
    (
        write('Invalid spot! Choose another.\n'),
        readColumn(Column),
        checkColumn(Column, NewColumn),
        readRow(Row),
        checkRow(Row, NewRow),
        validateStoneSpot(GameState, NewRow, NewColumn, FinalRow, FinalCol)
    ).
