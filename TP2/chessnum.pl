:- use_module(library(clpfd)).
:- use_module(library(lists)).
:-consult('puzzels.pl').
:-consult('utils.pl').


% CHESS_NUM 

% Tabuleiro de problema é um 8x8

% NOTA: https://erich-friedman.github.io/puzzle/chessnum/

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
% [_,_,4,_,_,_,_,_]  4 da Torre,Bispo,Cavaleiro,Peao (? DESDE QUANDO É QUE O PEAO ATACA NA DIAGONAL ?)
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


chessnum:-
    puzzle1(Tabuleiro),
    nl,
    printBoard(Tabuleiro),
    getAttacksValues(Tabuleiro, 0, ListAttackValues), % ListAttackValues -> [AttackValue - Row - Column,...]
    sort(ListAttackValues, AttacksList),
    write('Attacks List: '), write(AttacksList), nl,

    Positions = [KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC],
    domain(Positions, 0, 7),
    differentPositions(Positions),
    % falta restriçao de nao poderem ocupar posiçoes numeradas
    differentPosAttacks(Positions, AttacksList),
    maplist(sumAttacks(Positions), AttacksList),
    write('HELLO\n'),
    labeling([], Positions),
    write('Positions: '), write(Positions),nl,
    write('King is in '), write(KingR), write(KingC), nl,
    write('Queen is in '), write(QueenR), write(QueenC), nl,
    write('Rook is in '), write(RookR), write(RookC), nl,
    write('Bishop is in '), write(BishopR), write(BishopC), nl,
    write('Knight is in '), write(KnightR), write(KnightC), nl,
    write('Pawn is in '), write(PawnR), write(PawnC),
    replaceValueMatrix(Tabuleiro, KingR, KingC, king, Tabuleiro1),
    replaceValueMatrix(Tabuleiro1, QueenR, QueenC, queen, Tabuleiro2),
    replaceValueMatrix(Tabuleiro2, RookR, RookC, rook, Tabuleiro3),
    replaceValueMatrix(Tabuleiro3, BishopR, BishopC, bishop, Tabuleiro4),
    replaceValueMatrix(Tabuleiro4, KnightR, KnightC, knight, Tabuleiro5),
    replaceValueMatrix(Tabuleiro5, PawnR, PawnC, pawn, Tabuleiro6),
    printBoard(Tabuleiro6).

sumAttacks([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], Attack - Row - Column):-
    KingAttack + QueenAttack + RookAttack + BishopAttack + KnightAttack + PawnAttack #= Attack,
    validatePawnMove(PawnR, PawnC, Row, Column, PawnAttack),
    validateKnightMove(KnightR, KnightC, Row, Column, KingAttack),
    validateBishopMove(BishopR, BishopC, Row, Column, BishopAttack),
    validateKingMove(KingR, KingC, Row, Column, KingAttack),
    validateRookMove(RookR, RookC, Row, Column, RookAttack),
    validateQueenMove(QueenR, QueenC, Row, Column, QueenAttack).


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

differentPosAttacks([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], []).

differentPosAttacks([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], [_ - Row - Col | T]) :-
    KingR #\= Row,
    KingC #\= Col,
    QueenR #\= Row,
    QueenC #\= Col,
    RookR #\= Row,
    RookC #\= Col,
    BishopR #\= Row,
    BishopC #\= Col,
    KnightR #\= Row,
    KnightC #\= Col,
    PawnR #\= Row,
    PawnC #\= Col,
    differentPosAttacks([KingR, KingC, QueenR, QueenC, RookR, RookC, BishopR, BishopC, KnightR, KnightC, PawnR, PawnC], T).


validateKingMove(KingR, KingC, Row, Col, 1):-
    Row #=< (KingR + 1),
    Row #>= (KingR - 1),
    Col #>= (KingC - 1),
    Col #=< (KingC + 1).

validateKingMove(KingR, KingC, Row, Col, 0).

validateRookMove(RookR, RookC, Row, Col, 1):-
    RookC #= Col; 
    RookR #= Row.

validateRookMove(RookR, RookC, Row, Col, 0).

validateBishopMove(BishopR, BishopC, Row, Col, 1):-
    % Distance is 0,
    % maxDistanceBishop(Distance,BishopR,BishopC,Row,Col,Board), %doenst allow to skip pieces (should)
    DifR #= abs(BishopR - Row),
    DifC #= abs(BishopC - Col),
    % DifC < Distance, DifR < Distance,
    BishopC #\= Col , BishopR #\= Row,
    DifC #= DifR.

validateBishopMove(BishopR, BishopC, Row, Col, 0).

validateQueenMove(QueenR, QueenC, Row, Col, 1):-
    QueenC #= Col; 
    QueenR #= Row.

validateQueenMove(QueenR, QueenC, Row, Col, 1) :-
    DifR #= abs(QueenR - Row),
    DifC #= abs(QueenC - Col),
    QueenC #\= Col , QueenR #\= Row,
    DifC #= DifR.

validateQueenMove(QueenR, QueenC, Row, Col, 0).

validateKnightMove(KnightR, KnightC, Row, Col, 1):-
    (Row #= (KnightR + 2), Col #= (KnightC - 1));
    (Row #= (KnightR + 1), Col #= (KnightC - 2));
    (Row #= (KnightR + 2), Col #= (KnightC + 1));
    (Row #= (KnightR + 1), Col #= (KnightC + 2));
    (Row #= (KnightR - 2), Col #= (KnightC - 1));
    (Row #= (KnightR - 1), Col #= (KnightC - 2));
    (Row #= (KnightR - 2), Col #= (KnightC + 1));
    (Row #= (KnightR - 1), Col #= (KnightC + 2)).

validateKnightMove(KnightR, KnightC, Row, Col, 0).

validatePawnMove(PawnR, PawnC, Row, Col, 1) :-
    Col #= PawnC + 1,
    Row #= PawnR - 1.

validatePawnMove(PawnR, PawnC, Row, Col, 1) :-
    Col #= PawnC - 1,
    Row #= PawnR - 1.

validatePawnMove(PawnR, PawnC, Row, Col, 0).

% Matriz com posiçoes de ataque da Torre
generateRookMove(Row,Col,Matrix):- 
    generate_matrix(8,8,MatrixVazia),
    validateRookMove(Row,Col,X,Y),
    replaceValueMatrix(MatrixVazia,X,Y,1,Matrix).

% Matriz com posiçoes de ataque da Rainha
generateQueenMove(QueenR, QueenC, Matrix) :-
    generate_matrix(8, 8, MatrixVazia),
    validateQueenMove(Row, Col, X, Y),
    replaceValueMatrix(MatrixVazia,X,Y,1,Matrix),!.

% Matriz com posiçoes de ataque do Bispo
generateBishopMove(BishopR, BishopC, Matrix) :-
    generate_matrix(8, 8, MatrixVazia),
    validateBishopMove(BishopR, BishopC, X, Y),
    replaceValueMatrix(MatrixVazia,X,Y,1,Matrix),!.

% Matriz com posiçoes de ataque do Peão
generatePawnMove(PawnR, PawnC, Matrix) :-
    generate_matrix(8, 8, MatrixVazia),
    validatePawnMove(PawnR, PawnC, X, Y),
    replaceValueMatrix(MatrixVazia,X,Y,1,Matrix),!.


% Matriz com posiçoes de ataque do Rei
/*generateKingMove(Row,Col,Matrix):- 
    generate_matrix(8,8,MatrixVazia),
    length(Xs, 7),
    domain(Xs, 1, 7),
    all_distinct(Xs),
    print(Xs+'\n'),
    length(Ys, 7),
    domain(Ys, 1, 7),
    all_distinct(Ys),
    print(Ys+'\n'),
    member(X,Xs),
    member(Y,Ys),
    X #=< (Row + 1),
    X #>= (Row - 1),
    Y #>= (Col - 1),
    Y #=< (Col + 1),
    labeling([],Xs),
    labeling([],Ys),
    replaceValueMatrix(MatrixVazia,X,Y,1,Matrix),!.*/

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

