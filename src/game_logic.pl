calculateScore(_GameState,[],Score1,Score1).

calculateScore(GameState,[H|[H2|T]],Score, ScorePlus):-
    write('Started...\n'),

    check(GameState,H,H2,Score,Score1),
    calculateScore(GameState,T,Score1,ScorePlus).

increment(Content,Score,ScorePlus):-
    Content==empty,
    ScorePlus is Score.

increment(Content,Score,ScorePlus):-
    ScorePlus is Score + 1.

check(GameState, Row, Col, Score, Plus):-
    checkValueMatrix(GameState, Row, Col, Content),
    increment(Content,Score,Plus).

/*9 casos diferentes de posições no board*/
getAdjacentes(GameState,Row,Col,Adj):-
    Row==0, Column==0, 
    append([1,0],[], Adj1),
    append([0,1],Adj1, Adj2),
    append([1,1],Adj2, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==6, Column==0, 
    append([5,0],[], Adj1),
    append([5,1],Adj1, Adj2),
    append([6,1],Adj2, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==0, Column==6, 
    append([0,5],[], Adj1),
    append([1,6],Adj1, Adj2),
    append([1,5],Adj2, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==6, Column==6, 
    append([5,5],[], Adj1),
    append([6,5],Adj1, Adj2),
    append([5,6],Adj2, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==0,
    append([Row+1,Col],[], Adj1),
    append([Row,Col-1],Adj1, Adj2),
    append([Row,Col+1],Adj2, Adj3),
    append([Row+1,Col+1],Adj3, Adj3),
    append([Row+1,Col-1],Adj3, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==6,
    append([Row-1,Col],[], Adj1),
    append([Row,Col-1],Adj1, Adj2),
    append([Row,Col+1],Adj2, Adj3),
    append([Row-1,Col+1],Adj3, Adj4),
    append([Row-1,Col-1],Adj4, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Col==0,
    append([Row+1,Col],[], Adj1),
    append([Row-1,Col],Adj1, Adj2),
    append([Row+1,Col+1],Adj2, Adj3),
    append([Row,Col+1],Adj3, Adj4),
    append([Row-1,Col+1],Adj4, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Col==6,
    append([Row+1,Col],[], Adj1),
    append([Row-1,Col],Adj1, Adj2),
    append([Row+1,Col-1],Adj2, Adj3),
    append([Row,Col-1],Adj3, Adj4),
    append([Row-1,Col-1],Adj4, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    append([Row+1,Col],[], Adj1),
    append([Row-1,Col],Adj1, Adj2),
    append([Row+1,Col+1],Adj2, Adj3),
    append([Row-1,Col+1],Adj3, Adj4),
    append([Row,Col+1],Adj4, Adj5),
    append([Row+1,Col-1],Adj5, Adj6),
    append([Row-1,Col-1],Adj6, Adj7),
    append([Row,Col-1],Adj7, Adj).




    




    
