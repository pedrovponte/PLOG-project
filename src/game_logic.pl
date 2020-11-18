calculateScore(GameState,Adj,Score, ScorePlus):-
    write('Started...\n'),
    
    Column1 is Col-1,
    Column2 is Col+1,
    Row1 is Row-1,
    Row2 is Row+1,



    checkValueMatrix(GameState, Row, Column1, Content1),
    checkValueMatrix(GameState, Row1, Column1, Content2),
    checkValueMatrix(GameState, Row2, Column1, Content3),
    checkValueMatrix(GameState, Row, Column2, Content4),
    checkValueMatrix(GameState, Row1, Column2, Content5),
    checkValueMatrix(GameState, Row2, Column2, Content6),
    checkValueMatrix(GameState, Row1, Col, Content7),
    checkValueMatrix(GameState, Row2, Col, Content8),

    increment(Content1,Score,Score1),
    increment(Content2,Score1,Score2),
    increment(Content3,Score2,Score3),
    increment(Content4,Score3,Score4),
    increment(Content5,Score4,Score5),
    increment(Content6,Score5,Score6),
    increment(Content7,Score6,Score7),
    increment(Content8,Score7,ScorePlus).

increment(Content,Score,ScorePlus):-
    Content==empty,
    ScorePlus is Score.

increment(Content,Score,ScorePlus):-
    ScorePlus is Score +1.

/*getAdjacentes(GameState,Row,Col,Adj):-
    Row==0, Column==0, 
    append([1,0],[], Adj),
    append([0,1],Adj, Adj),
    append([1,1],Adj, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==6, Column==0, 
    append([5,0],[], Adj),
    append([,1],Adj, Adj),
    append([1,1],Adj, Adj).

check([H|T],Content):-
    checkValueMatrix(GameState, nth0(H,), Column1, Content1),*/






    
