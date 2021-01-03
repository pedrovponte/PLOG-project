:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).
:-consult('puzzels.pl').
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

%_________________________________________________________________________________________________

% gerar todas as posiçoes possiveis de todas as peças e, para cada uma dessas opções, calcular o ataque na posição Row,Col

%   Posicoes[King,Queen,Torre,Bispo,Cavaleiro,Peao]
%   Posicoes[00,32,46,33,78,65] significa: 
%       King na linha 0 coluna 0, 
%       Queen na linha 3 coluna 2, ...

%   restriçao: as peças nao podem ocupar casas numeradas
%   restriçao: duas peças nao podem ocupar a mesma casa

%   genarateKingMove(X1,Y1,Matrix1) //serao matrizes so com vazios e uns.
%   genarateQueenMove(X2,Y2,Matrix2)
%   genarateRookMove(X3,Y3,Matrix3)
%   genarateBishopMove(X4,Y4,Matrix4)
%   generateKnightMove(X5,Y5,Matrix5)
%   generatePawnMove(X6, Y6, Matrix6)
%    ...

%   sumMatrixs(1,2,Matrix1,Matrix2,Matrix3,Matrix4,Matrix5,Matrix6,Result1)
%   Result1 #= 4, 
%   sumMatrixs(3,6,Matrix1,Matrix2,Matrix3,Matrix4,Matrix5,Matrix6,Result2)
%   Result2 #= 4, 
%   sumMatrixs(5,0,Matrix1,Matrix2,Matrix3,Matrix4,Matrix5, Matrix6,Result3)
%   Result3 #= 0, 
%   sumMatrixs(7,2,Matrix1,Matrix2,Matrix3,Matrix4,Matrix5,Matrix6,Result4)
%   Result4 #= 4, 
%
%   labeling([],Posicoes).

% ou entao simplesmente somar as matrizes todas e comparar com a matriz inicial, pois o quantidade de numeros na matriz nao e igual em todas

printStatistics(RunTime):-
    nl,
    write('Solution Time: '), write(RunTime),write('ms'), nl,
    start.

get_tabuleiro(Id):-
    puzzle(Id,Tabuleiro),
    chessnum(Tabuleiro,RunTime,7),
    printStatistics(RunTime).

chessnum(Tabuleiro,RunTime,Size):-
    nl,

    % printBoard(Tabuleiro),
    statistics(runtime,[Start|_]),
    getAttacksValues(Tabuleiro, 0, ListAttackValues), % ListAttackValues -> [AttackValue - Row - Column,...]
    sort(ListAttackValues, AttacksList),
    write('Attacks List: '), write(AttacksList), nl,

    Positions = [KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC],
    domain(Positions, 0, Size),
    differentPositions(Positions),

    /*findall(A,sumAttacks(Positions,A),Bag),
    write('Bag: '), write(Bag), nl,
    nth0(0,Bag,Primeiro),
    write('Bag 0 : '), write(Primeiro),nl,*/

    maplist(sumAttacks(Positions), AttacksList),
    /*write('Attacks List 2: '), write(AttacksList), nl,*/

    /*nth0(0,AttacksList,Primeiro),
    write('First : '), write(Primeiro),nl,
    nth0(1,AttacksList,Segundo),
    write('Segundo : '), write(Segundo),nl,
    nth0(2,AttacksList,Terceiro),
    write('Terceiro : '), write(Terceiro),nl,
    nth0(3,AttacksList,Quarto),
    write('Quarto : '), write(Quarto),nl,

    sumAttacks(Positions,Primeiro),
    sumAttacks(Positions,Segundo),
    sumAttacks(Positions,Terceiro),
    sumAttacks(Positions,Quarto),*/
    
    write('Before labeling'), nl,
    labeling([], Positions),
   
    statistics(runtime,[Stop|_]),
   /* write('Positions: '), write(Positions),nl,
    write('King is in '), write(KingR), write(KingC), nl,
    write('Queen is in '), write(QueenR), write(QueenC), nl,
    write('Rook is in '), write(RookR), write(RookC), nl,
    write('Bishop is in '), write(BishopR), write(BishopC), nl,
    write('Knight is in '), write(KnightR), write(KnightC), nl,
    write('Pawn is in '), write(PawnR), write(PawnC),*/

    replaceValueMatrix(Tabuleiro, KingR, KingC, king, Tabuleiro1),
    replaceValueMatrix(Tabuleiro1, QueenR, QueenC, queen, Tabuleiro2),
    replaceValueMatrix(Tabuleiro2, RookR, RookC, rook, Tabuleiro3),
    replaceValueMatrix(Tabuleiro3, BishopR, BishopC, bishop, Tabuleiro4),
    replaceValueMatrix(Tabuleiro4, KnightR, KnightC, knight, Tabuleiro5),
    replaceValueMatrix(Tabuleiro5, PawnR, PawnC, pawn, Tabuleiro6),
    printBoard(Tabuleiro6),

    RunTime is Stop - Start.

sumAttacks([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Attack - Row - Column):-
    KingAttack + QueenAttack + RookAttack + BishopAttack + KnightAttack + PawnAttack #= Attack,
    
    (PawnR #\= Row #/\ PawnC #\= Column) #\/ (PawnR #= Row #/\ PawnC #\= Column)#\/ (PawnR #\= Row #/\ PawnC #= Column),
    validatePawnMove(PawnR, PawnC, Row, Column, PawnAttack),
    write('Pawn Attack: '), write(PawnAttack), nl,
    
    (RookR #\= Row #/\ RookC #\= Column) #\/ (RookR #= Row #/\ RookC #\= Column)#\/ (RookR #\= Row #/\ RookC #= Column),
    checkRookPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Column, [K1, Q1, B1, Kn1, P1]),
    validateRookMove(RookR, RookC, Row, Column, [K1, Q1, B1, Kn1, P1], RookAttack),
    write('Rook Attack: '), write(RookAttack), nl,
    
    (KnightR #\= Row #/\ KnightC #\= Column) #\/ (KnightR #= Row #/\ KnightC #\= Column)#\/ (KnightR #\= Row #/\ KnightC #= Column),
    validateKnightMove(KnightR, KnightC, Row, Column, KnightAttack),
    write('Knight Attack: '), write(KnightAttack), nl,
    
    (BishopR #\= Row #/\ BishopC #\= Column) #\/ (BishopR #= Row #/\ BishopC #\= Column)#\/ (BishopR #\= Row #/\ BishopC #= Column),
    checkBishopPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Column, [K1, Q1, R1, Kn1, P1]),
    validateBishopMove(BishopR, BishopC, Row, Column, [K1, Q1, R1, Kn1, P1], BishopAttack),
    write('Bishop Attack: '), write(BishopAttack), nl,
    
    (KingR #\= Row #/\ KingC #\= Column) #\/ (KingR #= Row #/\ KingC #\= Column)#\/ (KingR #\= Row #/\ KingC #= Column),
    validateKingMove(KingR, KingC, Row, Column, KingAttack),
    write('King Attack: '), write(KingAttack), nl,
    
    (QueenR #\= Row #/\ QueenC #\= Column) #\/ (QueenR #= Row #/\ QueenC #\= Column)#\/ (QueenR #\= Row #/\ QueenC #= Column),
    checkQueenPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Column, [K1, R1, B1, Kn1, P1]),
    validateQueenMove(QueenR, QueenC, Row, Column, [K1, R1, B1, Kn1, P1], QueenAttack),
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
validateKingMove(KingR, KingC, Row, Col, Attack):-
    /*(
        (Row #= (KingR -1) #/\ Col #= (KingC - 1)) #\/
        (Row #= KingR #/\ Col #= (KingC - 1)) #\/
        (Row #= (KingR+1) #/\ Col #= (KingC - 1)) #\/

        (Row #= (KingR -1) #/\ Col #= (KingC + 1)) #\/
        (Row #= KingR #/\ Col #= (KingC + 1)) #\/
        (Row #= (KingR+1) #/\ Col #= (KingC + 1)) #\/

        (Row #= (KingR -1) #/\ Col #= (KingC)) #\/
        (Row #= (KingR+1) #/\ Col #= (KingC))
    ) #<=> Attack.*/
    (
        Row #=< (KingR + 1) #/\
        Row #>= (KingR - 1) #/\
        Col #>= (KingC - 1) #/\
        Col #=< (KingC + 1)
    ) #<=> Attack.

% validateKingMove(KingR, KingC, Row, Col, 0).

/* Rook Move */
validateRookMove(RookR, RookC, Row, Col, [K1, Q1, B1, Kn1, P1], Attack):-
    (
        (Col #= RookC) #\/ 
        (Row #= RookR)
    ) #<=> Attack1,

    Attack #<=> Attack1 #/\ K1 #/\ Q1 #/\ B1 #/\ Kn1 #/\ P1.

/*validateRookMove(RookR, RookC, Row, Col, 1):-
    Row #= RookR.

validateRookMove(RookR, RookC, Row, Col, 0).*/

/* Bishop Move */
validateBishopMove(BishopR, BishopC, Row, Col, [K1, Q1, R1, Kn1, P1], Attack) :-
    (
        DifR #= abs(BishopR - Row) #/\
        DifC #= abs(BishopC - Col) #/\
        BishopC #\= Col #/\ BishopR #\= Row #/\
        DifC #= DifR
    ) #<=> Attack1,

    Attack #<=> Attack1 #/\ K1 #/\ Q1 #/\ R1 #/\ Kn1 #/\ P1.

% validateBishopMove(BishopR, BishopC, Row, Col, 0).

/* Queen Move */
validateQueenMove(QueenR, QueenC, Row, Col, [K1, R1, B1, Kn1, P1], Attack):-
    (
        QueenC #= Col #\/
        QueenR #= Row #\/
        (
            DifR #= abs(QueenR - Row) #/\
            DifC #= abs(QueenC - Col) #/\
            QueenC #\= Col #/\ QueenR #\= Row #/\
            DifC #= DifR
        )
    ) #<=> Attack1,

    Attack #<=> Attack1 #/\ K1 #/\ R1 #/\ B1 #/\ Kn1 #/\ P1. 

/*validateQueenMove(QueenR, QueenC, Row, Col, 1):-
    QueenR #= Row.

validateQueenMove(QueenR, QueenC, Row, Col, 1) :-
    DifR #= abs(QueenR - Row),
    DifC #= abs(QueenC - Col),
    QueenC #\= Col, QueenR #\= Row,
    DifC #= DifR.
validateQueenMove(QueenR, QueenC, Row, Col, 0).*/

/* Knight Move */
validateKnightMove(KnightR, KnightC, Row, Col, Attack) :-
    (
        (Row #= (KnightR + 2) #/\ Col #= (KnightC - 1)) #\/
        (Row #= (KnightR + 1) #/\ Col #= (KnightC - 2)) #\/
        (Row #= (KnightR + 2) #/\ Col #= (KnightC + 1)) #\/
        (Row #= (KnightR + 1) #/\ Col #= (KnightC + 2)) #\/
        (Row #= (KnightR - 2) #/\ Col #= (KnightC - 1)) #\/
        (Row #= (KnightR - 1) #/\ Col #= (KnightC - 2)) #\/
        (Row #= (KnightR - 2) #/\ Col #= (KnightC + 1)) #\/
        (Row #= (KnightR - 1) #/\ Col #= (KnightC + 2))
    ) #<=> Attack.

% validateKnightMove(KnightR, KnightC, Row, Col, 0).

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

/*validatePawnMove(PawnR, PawnC, Row, Col, 1) :-
    Col #= PawnC - 1,
    Row #= PawnR - 1.

validatePawnMove(PawnR, PawnC, Row, Col, 0).*/

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

checkQueenPositions([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Row, Col, [K1, R1, B1, Kn1, P1]) :-
    checkPieceRow(Row, Col, KingR, KingC, QueenR, QueenC, KR),
    checkPieceCol(Row, Col, KingR, KingC, QueenR, QueenC, KC),
    checkPieceDiagonal(Row, Col, KingR, KingC, QueenR, QueenC, KD),
    K1 #<=> KR #\/ KC #\/ KD,
    checkPieceRow(Row, Col, RookR, RookC, QueenR, QueenC, RR),
    checkPieceCol(Row, Col, RookR, RookC, QueenR, QueenC, RC),
    checkPieceDiagonal(Row, Col, RookR, RookC, QueenR, QueenC, RD),
    R1 #<=> RR #\/ RC #\/ RD,
    checkPieceRow(Row, Col, BishopR, BishopC, QueenR, QueenC, BR),
    checkPieceCol(Row, Col, BishopR, BishopC, QueenR, QueenC, BC),
    checkPieceDiagonal(Row, Col, BishopR, BishopC, QueenR, QueenC, BD),
    B1 #<=> BR #\/ BC #\/ BD,
    checkPieceRow(Row, Col, KnightR, KnightC, QueenR, QueenC, KnR),
    checkPieceCol(Row, Col, KnightR, KnightC, QueenR, QueenC, KnC),
    checkPieceDiagonal(Row, Col, KnightR, KnightC, QueenR, QueenC, KnD),
    Kn1 #<=> KnR #\/ KnC #\/ KnD,
    checkPieceRow(Row, Col, PawnR, PawnC, QueenR, QueenC, PR),
    checkPieceCol(Row, Col, PawnR, PawnC, QueenR, QueenC, PC),
    checkPieceDiagonal(Row, Col, PawnR, PawnC, QueenR, QueenC, PD),
    P1 #<=> PR #\/ PC #\/ PD.

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
            MovedR #= CelR #/\
            IntR #= MovedR #/\
            (((IntC #< MovedC) #/\ (MovedC #< CelC)) #\/ ((IntC #> MovedC) #/\ (MovedC #> CelC)))
        ) #\/
        (
            MovedR #= CelR #/\
            IntR #\= MovedR
        )
    ) #<=> Val.

% se estiverem na mesma coluna, retorna 0 se estiver compreendido entre a linha da celula e da peça
checkPieceCol(CelR, CelC, IntR, IntC, MovedR, MovedC, Val) :- % Moved - rainha/torre Int - outra peça Cel - celula ataque
    (
        (
            MovedC #= CelC #/\
            IntC #= MovedC #/\
            (((IntR #< MovedR) #/\ (MovedR #< CelR)) #\/ ((IntR #> MovedR) #/\ (MovedR #> CelR)))
        ) #\/
        (
            MovedC #= CelC #/\
            IntC #\= MovedC
        )
    ) #<=> Val.

% se estiverem na mesma diagonal, retorna 0 se tiver a meio da diagonal
checkPieceDiagonal(CelR, CelC, IntR, IntC, MovedR, MovedC, Val) :- % Moved - rainha/bispo Int - outra peça Cel - celula ataque
    DistR #= abs(MovedR - CelR) #/\
    DistC #= abs(MovedC - CelC) #/\
    DistRP #= abs(MovedR - IntR) #/\
    DistCP #= abs(MovedC - IntC) #/\
    (
        (
            DistR #= DistC #/\              % rainha / bispo na diagonal da celula de ataque
            DistRP #= DistCP #/\            % rainha / bispo tem na diagonal uma peça
            (                               % diagonal direita inferior
                IntR #> MovedR #/\          % linha da peça intermedia é superior a linha da rainha / bispo
                IntC #> CelC                % coluna da peça intermedia e superior a coluna da celula atacada, permitindo o ataque 
            ) #/\
            (                               % diagonal esquerda inferior
                IntR #> MovedR #/\          % linha da peça intermedia e superior a linha da rainha / bispo
                IntC #< CelC                % coluna da peça intermedia e inferior a coluna da celula atacada, permitindo o ataque
            ) #/\
            (                               % diagonal direita superior
                IntR #< MovedR #/\          % linha da peça intermedia e inferior a linha da rainha / bispo
                IntC #> CelC                % coluna da peça intermedia e superior a coluna da celula atacada, permitindo ataque
            ) #/\
            (                               % diagonal esquerda superior
                IntR #< MovedR #/\          % linha da peça intermedia e inferior a linha da rainha / bispo
                IntC #< CelC                % coluna da peça intermedia e inferior a coluna da celula atacada, permitindo ataque
            )
        ) #\/
        (                                   
            DistR #= DistC #/\              % caso celula atacada e rainha / bispo estejam na diagona
            DistRP #\= DistCP               % caso a outra peça não esteja na diagonal da rainha / bispo
        )
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




/*
%max distance allowed to travel calculator for bishop
maxDistanceBishop(MaxDistance,BishopR,BishopC,Row,Col,Board):-
  DeltaR is (Row - BishopR),
  DeltaC is (Col - BishopC),
  ite(DeltaC > 0,
          ite(DeltaR > 0, maxDistanceBishopDir1(MaxDistance,BishopR,BishopC,Row,Col,Board), maxDistanceBishopDir2(MaxDistance,BishopR,BishopC,Row,Col,Board)),
          ite(DeltaR > 0, maxDistanceBishopDir4(MaxDistance,BishopR,BishopC,Row,Col,Board), maxDistanceBishopDir3(MaxDistance,BishopR,BishopC,Row,Col,Board))).


maxDistanceBishopDir1(MaxDistance,BishopR,BishopC,Row,Col,Board):-
    BishopR < Row,
    BishopC < Col,
    NBishopC is (BishopC + 1),
    NBishopR is (BishopR + 1),
    getPiece(NBishopC,NBishopR,Board,Piece),
    Piece == 0,
    MaxDistance1 is (MaxDistance + 1),
    maxDistanceBishopDir1(MaxDistance1,NBishopC,NBishopR,Row,Col,Board).

maxDistanceBishopDir2(MaxDistance,BishopR,BishopC,Row,Col,Board):-
    BishopR > Row,
    BishopC < Col,
    NBishopC is (BishopC + 1),
    NBishopR is (BishopR - 1),
    getPiece(NBishopC,NBishopR,Board,Piece),
    Piece == 0,
    MaxDistance1 is (MaxDistance + 1),
    maxDistanceBishopDir2(MaxDistance1,NBishopC,NBishopR,Row,Col,Board).


maxDistanceBishopDir3(MaxDistance,BishopR,BishopC,Row,Col,Board):-
    BishopR > Row,
    BishopC > Col,
    NBishopC is (BishopC - 1),
    NBishopR is (BishopR - 1),
    getPiece(NBishopC,NBishopR,Board,Piece),
    Piece == 0,
    MaxDistance1 is (MaxDistance + 1),
    maxDistanceBishopDir3(MaxDistance1,NBishopC,NBishopR,Row,Col,Board).


maxDistanceBishopDir4(MaxDistance,BishopR,BishopC,Row,Col,Board):-
    BishopR < Row,
    BishopC > Col,
    NBishopC is (BishopC - 1),
    NBishopR is (BishopR + 1),
    getPiece(NBishopC,NBishopR,Board,Piece),
    Piece == 0,
    MaxDistance1 is (MaxDistance + 1),
    maxDistanceBishopDir4(MaxDistance1,NBishopC,NBishopR,Row,Col,Board).
*/

