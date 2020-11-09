piece_to_move(GameState,Player):-
    read_column(Column),
    check_column(Column, CheckedColumn),
    read_row(Row),
    check_row(column,CheckedRow).

% select_spot():-

% read column from user
read_column(Column):-
    write('Choose a column (0 - 6): '),
    read(Column).

% read row from user 
read_row(Row):-
    write('Choose a row (A - G): '),
    read(Row).

% check if introduced column is valid
check_column(0,0).
check_column(1,1).
check_column(2,2).
check_column(3,3).
check_column(4,4).
check_column(5,5).
check_column(6,6).

% case not, asks for a new column
check_column(_,CheckedColumn):-
    write('Invalid column\nSelect again\n'),
    read_column(Column),
    check_column(Column,CheckedColumn).

% check if introduced row is valid
check_row('A','A').
check_row('B','B').
check_row('C','C').
check_row('D','D').
check_row('E','E').
check_row('F','F').
check_row('G','G').

% case not, asks for a new row
check_row(_,CheckedRow):-
    write('Invalid row\nSelect again\n'),
    read_row(Row),
    check_row(Row,CheckedRow).