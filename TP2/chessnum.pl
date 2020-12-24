:- use_module(library(clpfd)).
:-consult('puzzels.pl').
:-consult('utils.pl').

% CHESS_NUM 

% Tabuleiro de problema é um 8x8

% NOTA: https://erich-friedman.github.io/puzzle/chessnum/ o exemplo de um puzzel resolvido inicial é um exemplo inválido. Nao esta bem.

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

%    genarateKingMove(X1,Y1,Matrix1) //serao matrizes so com vazios e uns.
%    genarateQueenMove(X2,Y2,Matrix2)
%    genarateTorreMove(X3,Y3,Matrix3)
%    genarateBispoMove(X4,Y4,Matrix4)
%    ...

%    sumMatrixs(1,2,Matrix1,Matrix2,Matrix3,Matrix4,Result1)
%    Result1 #= 4, 
%    sumMatrixs(3,6,Matrix1,Matrix2,Matrix3,Matrix4,Result2)
%    Result2 #= 4, 
%    sumMatrixs(5,0,Matrix1,Matrix2,Matrix3,Matrix4,Result3)
%    Result3 #= 0, 
%    sumMatrixs(7,2,Matrix1,Matrix2,Matrix3,Matrix4,Result4)
%    Result4 #= 4, 
%
%    labeling([],Posicoes).


chessnum:-
    puzzle1(Tabuleiro),
    printBoard(Tabuleiro). %(...).

% Matriz com posiçoes de ataque do Rei
generateKingMove(Row,Col,Matrix):- 
    generate_matrix(8,8,MatrixVazia),
    validateKingMove(Row,Col,X,Y),
    replaceValueMatrix(MatrixVazia,X,Y,1,Matrix),!.

validateKingMove(KingR,KingC,Row,Col):-
    Row =< (KingR + 1),
    Row >= (KingR - 1),
    Col >= (KingC - 1),
    Col =< (KingC + 1).

% Matriz com posiçoes de ataque da Torre
generateRookMove(Row,Col,Matrix):- 
    generate_matrix(8,8,MatrixVazia),
    validateRookMove(Row,Col,X,Y),
    replaceValueMatrix(MatrixVazia,X,Y,1,Matrix),!.

validateRookMove(RookR,RookC,Row,Col):-
    RookC =:= Col ; RookR =:= Row.

/*
validateQueenMove(QueenR,QueenC,Row,Col):-
    validateRookMove(QueenR,QueenC,Row,Col) ;
    validateBishopMove(QueenR,QueenC,Row,Col).


validateBishopMove(BishopR,BishopC,Row,Col):-
    %Distance is 0,
    %maxDistanceBishop(Distance,BishopR,BishopC,Row,Col,Board), %doenst allow to skip pieces (should)
    DifR is abs(BishopR - Row),
    DifC is abs(BishopC - Col),
    %DifC < Distance, DifR < Distance,
    BishopC \= Col , BishopR \= Row,
    DifC == DifR.

validateKnightMove(KnightR,KnightC,Row,Col):-
    (Row =:= (KnightR + 2), Col =:= (KnightC - 1));
    (Row =:= (KnightR + 1), Col =:= (KnightC - 2));
    (Row =:= (KnightR + 2), Col =:= (KnightC + 1));
    (Row =:= (KnightR + 1), Col =:= (KnightC + 2));
    (Row =:= (KnightR - 2), Col =:= (KnightC - 1));
    (Row =:= (KnightR - 1), Col =:= (KnightC - 2));
    (Row =:= (KnightR - 2), Col =:= (KnightC + 1));
    (Row =:= (KnightR - 1), Col =:= (KnightC + 2)).


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

