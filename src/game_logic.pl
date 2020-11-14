calculateScore(GameState,Row,Col,Score):-
    checkValueMatrix(GameState, Row, Col-1, Content1),
    checkValueMatrix(GameState, Row-1, Col-1, Content2),
    checkValueMatrix(GameState, Row+1, Col-1, Content3),
    checkValueMatrix(GameState, Row, Col+1, Content4),
    checkValueMatrix(GameState, Row-1, Col+1, Content5),
    checkValueMatrix(GameState, Row+1, Col+1, Content6),
    checkValueMatrix(GameState, Row-1, Col, Content7),
    checkValueMatrix(GameState, Row+1, Col, Content8),
    Content1==empty,!,Score=1,
    Content2==empty,!,Score=2,
    Content3==empty,!,Score=3,
    Content4==empty,!,Score=4,
    Content5==empty,!,Score=5,
    Content6==empty,!,Score=6,
    Content7==empty,!,Score=7,
    Content8==empty,!,Score=8.




    
