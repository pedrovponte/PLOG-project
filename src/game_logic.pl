/*Score*/
calculateScore(_GameState,[],Score1,Score1).

calculateScore(GameState,[H|[H2|T]],Score, ScorePlus):-
    check(GameState,H,H2,Score,Score1),
    calculateScore(GameState,T,Score1,ScorePlus).

increment(Content,Score,ScorePlus):-
    (Content == empty; Content == stone),
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
    Row1 is Row+1,
    Col1 is Col+1,
    Col2 is Col-1,
    append([Row1,Col],[], Adj1),
    append([Row,Col2],Adj1, Adj2),
    append([Row,Col1],Adj2, Adj3),
    append([Row1,Col1],Adj3, Adj4),
    append([Row1,Col2],Adj4, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row==6,
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    append([Row2,Col],[], Adj1),
    append([Row,Col2],Adj1, Adj2),
    append([Row,Col1],Adj2, Adj3),
    append([Row2,Col1],Adj3, Adj4),
    append([Row2,Col2],Adj4, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Col==0,
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    append([Row1,Col],[], Adj1),
    append([Row2,Col],Adj1, Adj2),
    append([Row1,Col1],Adj2, Adj3),
    append([Row,Col1],Adj3, Adj4),
    append([Row2,Col1],Adj4, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Col==6,
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    append([Row1,Col],[], Adj1),
    append([Row2,Col],Adj1, Adj2),
    append([Row1,Col2],Adj2, Adj3),
    append([Row,Col2],Adj3, Adj4),
    append([Row2,Col2],Adj4, Adj).

getAdjacentes(GameState,Row,Col,Adj):-
    Row1 is Row+1,
    Row2 is Row-1,
    Col1 is Col+1,
    Col2 is Col-1,
    append([Row1,Col],[], Adj1),
    append([Row2,Col],Adj1, Adj2),
    append([Row1,Col1],Adj2, Adj3),
    append([Row2,Col1],Adj3, Adj4),
    append([Row,Col1],Adj4, Adj5),
    append([Row1,Col2],Adj5, Adj6),
    append([Row2,Col2],Adj6, Adj7),
    append([Row,Col2],Adj7, Adj).




/*End Game*/
checkGameOver(_Player,NextPlayer,Score):-
	Score==10,
	NextPlayer = end.

checkGameOver(Player,NextPlayer,_Score):-
	NextPlayer = Player.

endGame(YellowScore,RedScore):-
	format('Yellow Score: ~d.\n', YellowScore),
	format('Red Score: ~d.\n\n', RedScore),
	write('GAME ENDED').


    




    
