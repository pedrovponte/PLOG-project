# PLOG 2020/2021 - TP1

## Group: T3G?

| Name             | Number    | E-Mail                |
| ---------------- | --------- | --------------------- |
| Pedro Varandas da Costa Azevedo da Ponte	   | 201809694 | up201809694@fe.up.pt  |
| Mariana Oliveira Ramos    | 201806869 | up201806869@fe.up.pt  |

## Jin Li

Jin Li is a strategy game for 2 players. The players each control two fish in a pond. 
Players take turns during the game moving
their Koi.
On his turn, a player must do one of these
two things:
- SWIM and DROP: A Koi SWIMS to an empty
square adjacent (ortogonaly or diagonaly)
to its current location. Then the player
takes one of his stones and places it in
any empty square on the board (DROP).
If a player has run out of stones then he
does not DROP after a SWIM.
- JUMP: A Koi jumps over one stone in an
adjacent square (ortogonaly or diagonaly)
and lands on the empty square just
beyond the jumped stone. The jump must
be along a straight line and the Koi can
only jump over a single stone. When the
JUMP has been completed the player
does not DROP a stone.
After moving a Koi (and dropping a stone if
applicable), the player scores one point for each
other Koi adjacent to his Koi’s new location. A
player may score 1, 2, or 3 points on a turn. Use
the counters and the scoring tracks to keep
record of the points.
The first player to score 10 points wins. 

(ALTERNATE RULES)
- Start the Koi one square diagonally inset from
the corners.
- Give each player 6 stones instead of 10
- Play to 15 points instead of 10
- After a player drops his last stone, the other
player removes one stone from the board and
gives it to that player to use next turn. 

[Source](https://boardgamegeek.com/boardgame/68743/jin-li), 
[Rules](https://nestorgames.com/rulebooks/JINLI_EN.pdf)


## Internal representation of the GameState

- Initial Situation:

```
initialBoard([
[red,empty,empty,empty,empty,empty,red],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[yellow,empty,empty,empty,empty,empty,yellow]
]).

```

```
|---|---|---|---|---|---|---|
|RF |   |   |   |   |   | RF|
|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|YF |   |   |   |   |   | YF|
|---|---|---|---|---|---|---|

```




- Intermediate Situation:

```
intermidiateBord([
[empty,empty,empty,empty,empty,empty,empty],
[empty,red,stone,empty,empty,empty,red],
[empty,empty,empty,stone,empty,empty,empty],
[empty,empty,empty,empty,empty,empty,empty],
[empty,yellow,stone,empty,empty,empty,empty],
[empty,empty,empty,stone,empty,empty,empty],
[empty,empty,empty,stone,empty,empty,yellow]
]).
```

```
|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|   | RF| SS|   |   |   | RF|
|---|---|---|---|---|---|---|
|   |   |   | SS|   |   |   |
|---|---|---|---|---|---|---|
|   |   |   |   |   |   |   |
|---|---|---|---|---|---|---|
|   | YF| SS|   |   |   |   |
|---|---|---|---|---|---|---|
|   |   |   | SS|   |   |   |
|---|---|---|---|---|---|---|
|   |   |   | SS|   |   | YF|
|---|---|---|---|---|---|---|

```



- Final Situation:


