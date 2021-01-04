:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:-consult('puzzles.pl').
:-consult('utils.pl').
:-consult('menu.pl').


% CHESS_NUM 

% Tabuleiro de problema é um 8x8

% https://erich-friedman.github.io/puzzle/chessnum/

%        REI              RAINHA             TORRE              BISPO             CAVALEIRO            PEAO
% [_,_,_,_,_,_,_,_]  [_,_,_,_,_,_,1,_]  [_,_,1,_,_,_,_,_]  [_,1,_,_,_,_,_,_]  [_,_,_,1,_,1,_,_]  [_,_,_,_,_,_,_,_] 
% [_,_,_,_,_,_,_,_]  [1,_,_,_,_,_,1,_]  [_,_,1,_,_,_,_,_]  [_,_,1,_,_,_,_,_]  [_,_,1,_,_,_,1,_]  [_,_,_,_,_,_,_,_] 
% [_,_,_,_,_,_,_,_]  [_,1,_,_,_,_,1,_]  [_,_,1,_,_,_,_,_]  [_,_,_,1,_,_,_,1]  [_,_,_,_,C,_,_,_]  [_,P,_,_,_,_,_,_] 
% [_,_,_,_,_,_,_,_]  [_,_,1,_,_,_,1,_]  [1,1,T,1,1,1,1,1]  [_,_,_,_,1,_,1,_]  [_,_,1,_,_,_,1,_]  [_,_,_,_,_,_,_,_] 
% [_,_,_,_,_,_,_,_]  [_,_,_,1,_,_,1,_]  [_,_,1,_,_,_,_,_]  [_,_,_,_,_,B,_,_]  [_,_,_,1,_,1,_,_]  [_,_,_,_,_,_,_,_] 
% [_,_,_,_,_,_,_,_]  [_,_,_,_,1,_,1,_]  [_,_,1,_,_,_,_,_]  [_,_,_,_,1,_,1,_]  [_,_,_,_,_,_,_,_]  [_,_,_,_,_,_,_,_] 
% [1,1,1,_,_,_,_,_]  [_,_,_,_,_,1,1,1]  [_,_,1,_,_,_,_,_]  [_,_,_,1,_,_,_,1]  [_,_,_,_,_,_,_,_]  [_,_,_,_,_,_,_,_] 
% [1,K,1,_,_,_,_,_]  [1,1,1,1,1,1,Q,1]  [_,_,1,_,_,_,_,_]  [_,_,1,_,_,_,_,_]  [_,_,_,_,_,_,_,_]  [_,_,_,_,_,_,_,_] 



% [_,_,_,_,_,_,_,_] 
% [_,_,4,_,_,_,_,_]  4 da Torre,Bispo,Cavaleiro,Peao
% [_,P,_,_,C,_,_,_]   
% [_,_,T,_,_,_,4,_]  4 da Torre,Bispo,Rainha,Cavaleiro
% [_,_,_,_,_,B,_,_]
% [0,_,_,_,_,_,_,_]  0 ataques
% [_,_,_,_,_,_,_,_]
% [_,K,4,_,_,_,Q,_]  4 do Rei,Rainha,Torre,Bispo

printStatistics(RunTime):-
    nl,
    write('Solution Time: '), write(RunTime),write('ms'), nl,
    start.

get_tabuleiro(Id):-
    puzzle(Id,Tabuleiro),
    chessnum(Tabuleiro,RunTime,7),
    % test(Tabuleiro, RunTime,7),
    printStatistics(RunTime).

% to test puzzles withou waiting. Only have to uncomment line test on get_tabuleiro and comment chessnum line. Then put solutions to puzzle before labeling (all solutions are on the bottom)
test(Tabuleiro,RunTime,Size) :-
    nl,

    statistics(runtime,[Start|_]),

    printBoard(Tabuleiro),
    getAttacksValues(Tabuleiro, 0, ListAttackValues), % ListAttackValues -> [AttackValue - Row - Column,...]
    sort(ListAttackValues, AttacksList),
    write('Attacks List: '), write(AttacksList), nl,

    Positions = [KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC],
    domain(Positions, 0, Size),
    differentPositions(Positions),

    maplist(sumAttacks(Positions), AttacksList),
    
    % put puzzle solution
    KingR #= 5, 
    KingC #= 5, 
    QueenR #= 4, 
    QueenC #= 2, 
    RookR #= 6, 
    RookC #= 6, 
    BishopR #= 0, 
    BishopC #= 5, 
    KnightR #= 0, 
    KnightC #= 4, 
    PawnR #= 5, 
    PawnC #= 0,
    
    labeling([], Positions),

    replaceValueMatrix(Tabuleiro, KingR, KingC, king, Tabuleiro1),
    replaceValueMatrix(Tabuleiro1, QueenR, QueenC, queen, Tabuleiro2),
    replaceValueMatrix(Tabuleiro2, RookR, RookC, rook, Tabuleiro3),
    replaceValueMatrix(Tabuleiro3, BishopR, BishopC, bishop, Tabuleiro4),
    replaceValueMatrix(Tabuleiro4, KnightR, KnightC, knight, Tabuleiro5),
    replaceValueMatrix(Tabuleiro5, PawnR, PawnC, pawn, Tabuleiro6),
    printBoard(Tabuleiro6),

    statistics(runtime,[Stop|_]),

    RunTime is Stop - Start.
    


chessnum(Tabuleiro,RunTime,Size):-
    nl,

    statistics(runtime,[Start|_]),

    printBoard(Tabuleiro),
    getAttacksValues(Tabuleiro, 0, ListAttackValues), % ListAttackValues -> [AttackValue - Row - Column,...]
    sort(ListAttackValues, AttacksList),
    write('Attacks List: '), write(AttacksList), nl,

    Positions = [KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC],
    domain(Positions, 0, Size),
    differentPositions(Positions),

    maplist(sumAttacks(Positions), AttacksList),
    
    write('Before labeling'), nl,
    labeling([ffc], Positions),

    replaceValueMatrix(Tabuleiro, KingR, KingC, king, Tabuleiro1),
    replaceValueMatrix(Tabuleiro1, QueenR, QueenC, queen, Tabuleiro2),
    replaceValueMatrix(Tabuleiro2, RookR, RookC, rook, Tabuleiro3),
    replaceValueMatrix(Tabuleiro3, BishopR, BishopC, bishop, Tabuleiro4),
    replaceValueMatrix(Tabuleiro4, KnightR, KnightC, knight, Tabuleiro5),
    replaceValueMatrix(Tabuleiro5, PawnR, PawnC, pawn, Tabuleiro6),
    printBoard(Tabuleiro6),

    statistics(runtime,[Stop|_]),

    RunTime is Stop - Start.

sumAttacks([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Attack - Row - Column):-
    KingAttack + QueenAttack + RookAttack + BishopAttack + KnightAttack + PawnAttack #= Attack,
    
    (PawnR #\= Row #/\ PawnC #\= Column) #\/ (PawnR #= Row #/\ PawnC #\= Column) #\/ (PawnR #\= Row #/\ PawnC #= Column),
    validatePawnMove(PawnR, PawnC, Row, Column, PawnAttack),
    write('Pawn Attack: '), write(PawnAttack), nl,
    
    (RookR #\= Row #/\ RookC #\= Column) #\/ (RookR #= Row #/\ RookC #\= Column) #\/ (RookR #\= Row #/\ RookC #= Column),
    checkRookPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Column, [K1, Q1, B1, Kn1, P1]),
    validateRookMove(RookR, RookC, Row, Column, [K1, Q1, B1, Kn1, P1], RookAttack),
    write('Rook Attack: '), write(RookAttack), nl,
    
    (KnightR #\= Row #/\ KnightC #\= Column) #\/ (KnightR #= Row #/\ KnightC #\= Column) #\/ (KnightR #\= Row #/\ KnightC #= Column),
    validateKnightMove(KnightR, KnightC, Row, Column, KnightAttack),
    write('Knight Attack: '), write(KnightAttack), nl,
    
    (BishopR #\= Row #/\ BishopC #\= Column) #\/ (BishopR #= Row #/\ BishopC #\= Column) #\/ (BishopR #\= Row #/\ BishopC #= Column),
    checkBishopPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Column, [K2, Q2, R2, Kn2, P2]),
    validateBishopMove(BishopR, BishopC, Row, Column, [K2, Q2, R2, Kn2, P2], BishopAttack),
    write('Bishop Attack: '), write(BishopAttack), nl,
    
    (KingR #\= Row #/\ KingC #\= Column) #\/ (KingR #= Row #/\ KingC #\= Column)#\/ (KingR #\= Row #/\ KingC #= Column),
    validateKingMove(KingR, KingC, Row, Column, KingAttack),
    write('King Attack: '), write(KingAttack), nl,
    
    (QueenR #\= Row #/\ QueenC #\= Column) #\/ (QueenR #= Row #/\ QueenC #\= Column)#\/ (QueenR #\= Row #/\ QueenC #= Column),
    checkQueenPositionsRowCol([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Column, [K3, R3, B3, Kn3, P3]),
    checkQueenPositionsDiagonal([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Column, [KD1, RD1, BD1, KnD1, PD1]),
    validateQueenMove(QueenR, QueenC, Row, Column, [K3, R3, B3, Kn3, P3], [KD1, RD1, BD1, KnD1, PD1],QueenAttack),
    write('Queen Attack: '), write(QueenAttack), nl,
    
    % KingAttack + QueenAttack + RookAttack + BishopAttack + KnightAttack + PawnAttack #= Attack,
    write('sumAttack over - '),write(Attack),write(' - '),write(Row),write(' - '),write(Column), nl,nl.


getAttacksValues(GameBoard, X, ListAttackValues) :-
    getAttacksValues(GameBoard, X, [], ListAttackValues).

getAttacksValues([H | L], X, AuxListAttackValues, ListAttackValues) :-
    getAttacksValuesLine(H, X, 0, LineAttacks),
    append(AuxListAttackValues, LineAttacks, Res),
    X1 is X + 1,
    getAttacksValues(L, X1, Res, ListAttackValues).

getAttacksValues(_, 8, ListAttackValues, ListAttackValues).

getAttacksValuesLine(Line, X, Y, LineAttacks) :-
    getAttacksValuesLine(Line, X, Y, [], LineAttacks).

getAttacksValuesLine([H | L], X, Y, AuxLineAttacks, LineAttacks) :-
    H \= empty,
    appendList(AuxLineAttacks, H - X - Y, Res),
    Y1 is Y + 1,
    getAttacksValuesLine(L, X, Y1, Res, LineAttacks).

getAttacksValuesLine([H | L], X, Y, AuxLineAttacks, LineAttacks) :- 
    H == empty,
    Y1 is Y + 1,
    getAttacksValuesLine(L, X, Y1, AuxLineAttacks, LineAttacks).

getAttacksValuesLine(_, _, 8, LineAttacks, LineAttacks).

differentPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC]) :-
    KingPos #= 10 * KingR + KingC,
    QueenPos #= 10 * QueenR + QueenC,
    RookPos #= 10 * RookR + RookC,
    BishopPos #= 10 * BishopR + BishopC,
    KnightPos #= 10 * KnightR + KnightC,
    PawnPos #= 10 * PawnR + PawnC,
    KingPos #\= QueenPos,
    KingPos #\= RookPos,
    KingPos #\= BishopPos,
    KingPos #\= KnightPos,
    KingPos #\= PawnPos,
    QueenPos #\= RookPos,
    QueenPos #\= BishopPos,
    QueenPos #\= KnightPos,
    QueenPos #\= PawnPos,
    RookPos #\= BishopPos,
    RookPos #\= KnightPos,
    RookPos #\= PawnPos,
    BishopPos #\= KnightPos,
    BishopPos #\= PawnPos,
    KnightPos #\= PawnPos.



/* King Move */
validateKingMove(KingR, KingC, Row, Col, Attack) :-
    (
        Row #=< (KingR + 1) #/\
        Row #>= (KingR - 1) #/\
        Col #>= (KingC - 1) #/\
        Col #=< (KingC + 1)
    ) #<=> Attack.

/* Rook Move */
validateRookMove(RookR, RookC, Row, Col, [K1, Q1, B1, Kn1, P1], Attack) :-
    (((RookR #= Row) #\/ (RookC #= Col)) #/\ K1 #/\ Q1 #/\ B1 #/\ Kn1 #/\ P1) #<=> Attack.

/* Bishop Move */
validateBishopMove(BishopR, BishopC, Row, Col, [K1, Q1, R1, Kn1, P1], Attack) :-

    ((abs(Row - BishopR) #= abs(Col - BishopC)) #/\ K1 #/\ Q1 #/\ R1 #/\ Kn1 #/\ P1) #<=> Attack.

/* Queen Move */
validateQueenMove(QueenR, QueenC, Row, Col, [K1, R1, B1, Kn1, P1], [KD1, RD1, BD1, KnD1, PD1], Attack):-
    ((((QueenR #= Row) #\/ (QueenC #= Col)) #/\ K1 #/\ R1 #/\ B1 #/\ Kn1 #/\ P1) #\/ (((abs(Row - QueenR) #= abs(Col - QueenC)) #/\ KD1 #/\ RD1 #/\ BD1 #/\ KnD1 #/\ PD1))) #<=> Attack.
    
    

/* Knight Move */
validateKnightMove(KnightR, KnightC, Row, Col, Attack) :-
    (
        (Row #= (KnightR + 2) #/\ Col #= (KnightC - 1)) #\/
        (Row #= (KnightR + 2) #/\ Col #= (KnightC + 1)) #\/
        (Row #= (KnightR + 1) #/\ Col #= (KnightC - 2)) #\/
        (Row #= (KnightR + 1) #/\ Col #= (KnightC + 2)) #\/
        (Row #= (KnightR - 2) #/\ Col #= (KnightC - 1)) #\/
        (Row #= (KnightR - 2) #/\ Col #= (KnightC + 1)) #\/
        (Row #= (KnightR - 1) #/\ Col #= (KnightC - 2)) #\/
        (Row #= (KnightR - 1) #/\ Col #= (KnightC + 2))
    ) #<=> Attack.

/* Pawn Move */
validatePawnMove(PawnR, PawnC, Row, Col, Attack) :-
    (
        (   
            Col #= PawnC + 1 #/\
            Row #= PawnR - 1
        ) #\/
        (
            Col #= PawnC - 1 #/\
            Row #= PawnR - 1
        ) 
    ) #<=> Attack.

checkRookPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Col, [K1, Q1, B1, Kn1, P1]) :-
    checkPieceRow(Row, Col, KingR, KingC, RookR, RookC, KR),
    checkPieceCol(Row, Col, KingR, KingC, RookR, RookC, KC),
    K1 #<=> KR #\/ KC,
    checkPieceRow(Row, Col, QueenR, QueenC, RookR, RookC, QR),
    checkPieceCol(Row, Col, QueenR, QueenC, RookR, RookC, QC),
    Q1 #<=> QR #\/ QC,
    checkPieceRow(Row, Col, BishopR, BishopC, RookR, RookC, BR),
    checkPieceCol(Row, Col, BishopR, BishopC, RookR, RookC, BC),
    B1 #<=> BR #\/ BC,
    checkPieceRow(Row, Col, KnightR, KnightC, RookR, RookC, KnR),
    checkPieceCol(Row, Col, KnightR, KnightC, RookR, RookC, KnC),
    Kn1 #<=> KnR #\/ KnC,
    checkPieceRow(Row, Col, PawnR, PawnC, RookR, RookC, PR),
    checkPieceCol(Row, Col, PawnR, PawnC, RookR, RookC, PC),
    P1 #<=> PR #\/ PC.

checkQueenPositionsRowCol([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Col, [K1, R1, B1, Kn1, P1]) :-
    checkPieceRow(Row, Col, KingR, KingC, QueenR, QueenC, KR),
    checkPieceCol(Row, Col, KingR, KingC, QueenR, QueenC, KC),
    K1 #<=> KR #\/ KC,
    checkPieceRow(Row, Col, RookR, RookC, QueenR, QueenC, RR),
    checkPieceCol(Row, Col, RookR, RookC, QueenR, QueenC, RC),
    R1 #<=> RR #\/ RC,
    checkPieceRow(Row, Col, BishopR, BishopC, QueenR, QueenC, BR),
    checkPieceCol(Row, Col, BishopR, BishopC, QueenR, QueenC, BC),
    B1 #<=> BR #\/ BC,
    checkPieceRow(Row, Col, KnightR, KnightC, QueenR, QueenC, KnR),
    checkPieceCol(Row, Col, KnightR, KnightC, QueenR, QueenC, KnC),
    Kn1 #<=> KnR #\/ KnC,
    checkPieceRow(Row, Col, PawnR, PawnC, QueenR, QueenC, PR),
    checkPieceCol(Row, Col, PawnR, PawnC, QueenR, QueenC, PC),
    P1 #<=> PR #\/ PC.

checkQueenPositionsDiagonal([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Col, [KD1, RD1, BD1, KnD1, PD1]) :-
    checkPieceDiagonal(Row, Col, KingR, KingC, QueenR, QueenC, KD1),
    checkPieceDiagonal(Row, Col, RookR, RookC, QueenR, QueenC, RD1),
    checkPieceDiagonal(Row, Col, BishopR, BishopC, QueenR, QueenC, BD1),
    checkPieceDiagonal(Row, Col, KnightR, KnightC, QueenR, QueenC, KnD1),
    checkPieceDiagonal(Row, Col, PawnR, PawnC, QueenR, QueenC, PD1).

checkBishopPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Col, [K1, Q1, R1, Kn1, P1]) :-
    checkPieceDiagonal(Row, Col, KingR, KingC, BishopR, BishopC, K1),
    checkPieceDiagonal(Row, Col, QueenR, QueenC, BishopR, BishopC, Q1),
    checkPieceDiagonal(Row, Col, RookR, RookC, BishopR, BishopC, R1),
    checkPieceDiagonal(Row, Col, KnightR, KnightC, BishopR, BishopC, Kn1),
    checkPieceDiagonal(Row, Col, PawnR, PawnC, BishopR, BishopC, P1).

% se estiverem na mesma linha, retorna 0 se estiver compreendido entre a coluna da celula e da peça
checkPieceRow(CelR, CelC, IntR, IntC, MovedR, MovedC, Val) :- % Moved - rainha/torre Int - outra peça Cel - celula ataque
    (
        (
            MovedR #= CelR #/\                  % rainha / torre estao na mesma linha da celula atacada
            IntR #= CelR #/\                    % peça intermedia esta na mesma linha que celula numerada
            CelC #> MovedC #/\                  % rainha / torre encontra-se a esquerda da celula atacada
            (IntC #< MovedC #\/ IntC #> CelC)   % peça intermedia encontra-se a esquerda da rainha / torre ou a direita da celula atacada
        ) #\/
        (
            MovedR #= CelR #/\                  % rainha / torre estao na mesma linha da celula atacada
            IntR #= CelR #/\                    % peça intermedia esta na mesma linha que celula numerada
            CelC #< MovedC #/\                  % rainha / torre encontra-se a direita da celula atacada
            (IntC #< CelC #\/ IntC #> MovedC)   % peça intermedia encontra-se a esquerda da celula atacada ou a direita da rainha / torre
        ) #\/
        (
            MovedR #= CelR #/\                  % rainha / torre estao na mesma linha da celula atacada
            IntR #\= CelR                       % celula numerada nao esta na mesma linha que a peça intermedia
        )
    ) #<=> Val.

% se estiverem na mesma coluna, retorna 0 se estiver compreendido entre a linha da celula e da peça
checkPieceCol(CelR, CelC, IntR, IntC, MovedR, MovedC, Val) :- % Moved - rainha/torre Int - outra peça Cel - celula ataque
    (
        (
            MovedC #= CelC #/\                      % rainha / torre estao na mesma coluna da celula atacada
            IntC #= CelC #/\                      % peça intermedia esta na mesma coluna que a torre / rainha
            CelR #> MovedR #/\                      % rainha / torre encontra-se acima da celula atacada 
            ((IntR #< MovedR) #\/ (IntR #> CelR))   % peça intermedia esta acima da rainha / torre ou abaixo da celula atacada 
        ) #\/
        (
            MovedC #= CelC #/\                      % rainha / torre estao na mesma coluna da celula atacada
            IntC #= CelC #/\                      % peça intermedia esta na mesma coluna que a torre / rainha
            CelR #< MovedR #/\                      % rainha / torre encontra-se abaixo da celula atacada 
            ((IntR #< CelR) #\/ (IntR #> MovedR))   % peça intermedia esta acima da celula atacada ou abaixo da rainha / torre
        ) #\/
        (
            MovedC #= CelC #/\                      % rainha / torre estao na mesma coluna da celula atacada                  
            IntC #\= CelC                           % peça intermedia nao esta na mesma coluna que a celula atacada
        )
    ) #<=> Val.

% se estiverem na mesma diagonal, retorna 0 se tiver a meio da diagonal
checkPieceDiagonal(CelR, CelC, IntR, IntC, MovedR, MovedC, Val) :- % Moved - rainha/bispo Int - outra peça Cel - celula ataque
    (
        ((abs(CelR - MovedR) #= abs(CelC - MovedC)) #/\ (abs(CelR - IntR) #\= abs(CelC - IntC))) #\/
        ((abs(CelR - MovedR) #= abs(CelC - MovedC)) #/\ ((CelR #< MovedR) #/\ (CelC #> MovedC)) #/\ ((CelR #> IntR) #\/ (CelC #< IntC) #\/ (IntR #> MovedR) #\/ (IntC #< MovedC))) #\/
        ((abs(CelR - MovedR) #= abs(CelC - MovedC)) #/\ ((CelR #< MovedR) #/\ (CelC #< MovedC)) #/\ ((CelR #> IntR) #\/ (CelC #> IntC) #\/ (IntR #> MovedR) #\/ (IntC #> MovedC))) #\/
        ((abs(CelR - MovedR) #= abs(CelC - MovedC)) #/\ ((CelR #> MovedR) #/\ (CelC #> MovedC)) #/\ ((CelR #< IntR) #\/ (CelC #< IntC) #\/ (IntR #< MovedR) #\/ (IntC #< MovedC))) #\/
        ((abs(CelR - MovedR) #= abs(CelC - MovedC)) #/\ ((CelR #> MovedR) #/\ (CelC #< MovedC)) #/\ ((CelR #< IntR) #\/ (CelC #> IntC) #\/ (IntR #< MovedR) #\/ (IntC #> MovedC)))
    ) #<=> Val.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      Generate puzzles                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_puzzle(Board_Size) :-
    generate_matrix(Board_Size, Board_Size, Tabuleiro),
    random(0,Board_Size,Row1),
    random(0,Board_Size,Col1),
    random(0,Board_Size,Row2),
    random(0,Board_Size,Col2),
    random(0,Board_Size,Row3),
    random(0,Board_Size,Col3),
    random(0,Board_Size,Row4),
    random(0,Board_Size,Col4),
    random(0,Board_Size,Row5),
    random(0,Board_Size,Col5),
    random(0,Board_Size,Row6),
    random(0,Board_Size,Col6),
    Cell=[Row1,Col1,Row2,Col2,Row3,Col3,Row4,Col4,Row5,Col5,Row6,Col6],
    
    differentPositions(Cell),

    random(0,4,Num1),
    replaceValueMatrix(Tabuleiro,Row1,Col1,Num1,Tabuleiro1),
    random(0,4,Num2),
    replaceValueMatrix(Tabuleiro1,Row2,Col2,Num2,Tabuleiro2),
    random(0,4,Num3),
    replaceValueMatrix(Tabuleiro2,Row3,Col3,Num3,Tabuleiro3),
    random(0,4,Num4),
    replaceValueMatrix(Tabuleiro3,Row4,Col4,Num4,Tabuleiro4),
    printBoard(Tabuleiro4),

    chessnum(Tabuleiro4,RunTime, Board_Size),
    printStatistics(RunTime).

% solutions to all puzzles

/*
% puzzle 0 solution
    KingR #= 1, 
    KingC #= 3, 
    QueenR #= 0, 
    QueenC #= 6, 
    RookR #= 0, 
    RookC #= 2, 
    BishopR #= 3, 
    BishopC #= 0, 
    KnightR #= 1, 
    KnightC #= 1, 
    PawnR #= 1, 
    PawnC #= 4,

    % puzzle 1 solution
    KingR #= 7, 
    KingC #= 1, 
    QueenR #= 7, 
    QueenC #= 6, 
    RookR #= 3, 
    RookC #= 2, 
    BishopR #= 4, 
    BishopC #= 5, 
    KnightR #= 2, 
    KnightC #= 4, 
    PawnR #= 2, 
    PawnC #= 1,

    % puzzle 2 solution
    KingR #= 6, 
    KingC #= 7, 
    QueenR #= 1, 
    QueenC #= 7, 
    RookR #= 1, 
    RookC #= 6, 
    BishopR #= 2, 
    BishopC #= 7, 
    KnightR #= 3, 
    KnightC #= 6, 
    PawnR #= 1, 
    PawnC #= 1,

    % puzzle 3 solution
    KingR #= 5, 
    KingC #= 3, 
    QueenR #= 4, 
    QueenC #= 5, 
    RookR #= 4, 
    RookC #= 2, 
    BishopR #= 3, 
    BishopC #= 0, 
    KnightR #= 5, 
    KnightC #= 6, 
    PawnR #= 5, 
    PawnC #= 5,

    % puzzle 4 solution
    KingR #= 5, 
    KingC #= 5, 
    QueenR #= 3, 
    QueenC #= 3, 
    RookR #= 3, 
    RookC #= 5, 
    BishopR #= 1, 
    BishopC #= 5, 
    KnightR #= 3, 
    KnightC #= 7, 
    PawnR #= 5, 
    PawnC #= 4,

    % puzzle 5 solution
    KingR #= 1, 
    KingC #= 3, 
    QueenR #= 4, 
    QueenC #= 7, 
    RookR #= 3, 
    RookC #= 1, 
    BishopR #= 3, 
    BishopC #= 7, 
    KnightR #= 7, 
    KnightC #= 3, 
    PawnR #= 6, 
    PawnC #= 2,

    % puzzle 6 solution
    KingR #= 7, 
    KingC #= 4, 
    QueenR #= 3, 
    QueenC #= 3, 
    RookR #= 7, 
    RookC #= 7, 
    BishopR #= 3, 
    BishopC #= 4, 
    KnightR #= 0, 
    KnightC #= 2, 
    PawnR #= 7, 
    PawnC #= 3,

    % puzzle 7 solution
    KingR #= 5, 
    KingC #= 1, 
    QueenR #= 7, 
    QueenC #= 0, 
    RookR #= 7, 
    RookC #= 1, 
    BishopR #= 6, 
    BishopC #= 0, 
    KnightR #= 6, 
    KnightC #= 1, 
    PawnR #= 7, 
    PawnC #= 3,

    % puzzle 8 solution
    KingR #= 3, 
    KingC #= 3, 
    QueenR #= 4, 
    QueenC #= 3, 
    RookR #= 5, 
    RookC #= 4, 
    BishopR #= 3, 
    BishopC #= 1, 
    KnightR #= 2, 
    KnightC #= 0, 
    PawnR #= 5, 
    PawnC #= 3,

    % puzzle 9 solution
    KingR #= 2, 
    KingC #= 2, 
    QueenR #= 5, 
    QueenC #= 2, 
    RookR #= 7, 
    RookC #= 2, 
    BishopR #= 6, 
    BishopC #= 5, 
    KnightR #= 3, 
    KnightC #= 6, 
    PawnR #= 2, 
    PawnC #= 5,

    % puzzle 10 solution
    KingR #= 5, 
    KingC #= 5, 
    QueenR #= 4, 
    QueenC #= 2, 
    RookR #= 6, 
    RookC #= 6, 
    BishopR #= 0, 
    BishopC #= 5, 
    KnightR #= 0, 
    KnightC #= 4, 
    PawnR #= 5, 
    PawnC #= 0,
*/
