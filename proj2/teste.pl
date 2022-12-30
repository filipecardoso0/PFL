% -------------------Construct Board -----------------------

board(Elements, Board) :-
    Board = [Row1, Row2, Row3, Row4],
    Row1 = [E1, E2, E3, E4],
    Row2 = [E5, E6, E7, E8],
    Row3 = [E9, E10, E11, E12],
    Row4 = [E13, E14, E15, E16],
    Elements = [E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15, E16].

get_elements(Board, Elements) :-
    Board = [[E1, E2, E3, E4], [E5, E6, E7, E8], [E9, E10, E11, E12], [E13, E14, E15, E16]],
    Elements = [E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15, E16].

draw_board(Elements) :-
    length(Elements, Len),
    Len =:= 16, % make sure the input list has 16 elements
    Row1 = [E1, E2, E3, E4],
    Row2 = [E5, E6, E7, E8],
    Row3 = [E9, E10, E11, E12],
    Row4 = [E13, E14, E15, E16],
    Elements = [E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14, E15, E16],
    nl,
    write_row(Row1), nl,
    write_separator, nl,
    write_row(Row2), nl,
    write_separator, nl,
    write_row(Row3), nl,
    write_separator, nl,
    write_row(Row4), nl.

write_row([E1, E2, E3, E4]) :-
    write(E1),
    write(' | '),
    write(E2),
    write(' | '),
    write(E3),
    write(' | '),
    write(E4).

write_separator :-
    write('---+---+---+---').



% ------------------- Player Turn Menu -----------------------

/* TODO TENTAR COLOCAR AVISOS AO INVES DE EM CASO DE ERRO DETETADO OBRIGAR O JOGADOR A REINCIAR O JOGO */ 

player_turn(Elements, CurrPlayer):-
    write('Player: '), write(CurrPlayer), nl,
    write('Please select an action:'), nl,
    write('1- Drop a stone into an empty cell.'), nl,
    write('2- Move a stone into an adjacent(orthogonal or diagonal empty cell.'), nl,

    /* TODO ONLY LET PLAYER SELECT CHOICE 2 IF HE ALREADY HAS 1 STONE ON THE BOARD */
    /* TODO Option 3 - Jump over an enemy stone landing on the immediate empty cell, and capturing it; 
        	            - Jumps are mandatory and take precedence over drops and moves. 
                        - Multiple jumps, if possible, are required (no max capture rule) 

        TODO WIN - Wins the player that makes an orthogonal or diagonal 3 in-a-row, or captures 6 enemy stones.
    */

    read(Choice),
    (
        Choice = 1 -> drop_stone_menu(Elements, CurrPlayer); 
        Choice = 2 -> move_stone(Elements, CurrPlayer)
    ).


% ------------------- Move Stone -----------------------

/* NOTA (Remover depois): O board tem que ser indo passado a cada passo, pois é como se fosse um state pattern e corresponde ao estado atual do jogo */

move_stone(Elements, CurrPlayer):-
    write('Select which Stone do you want to move:'), nl, 
    write('Select the column where the stone is located (1-4):'), nl, 
    read(Col), 
    write('Select the row where the stone is located (1-4): '), nl, 
    read(Row), 

   /* Position index of the stone we are going to move*/
   Position is (Row-1)*4+Col,
   PositionIndex is Position-1, 
 
   /* Verify if the stone belongs to the player - TODO WHEN PLAYER VS PLAYER STARTS TO BE IMPLEMENTED  
   belongs_to_player(Elements, PositionIndex, player), */ 

   /* Select the movement type */ 
   movement_selector(Elements, PositionIndex, CurrPlayer).

/* Move a stone into an adjacent(orthogonal or diagonal empty cell */
movement_selector(Elements, PositionIndex, CurrPlayer):-
    write('Please Select the movement Type: '), nl,
    write('1- Orthogonal'), nl, 
    write('2- Diagonal'), nl, 
    read(Type),
    (
        Type = 1 -> show_options_orthogonal(Elements, PositionIndex, CurrPlayer); 
        Type = 2 -> move_diagonal(Elements, PositionIndex, CurrPlayer)
    ).

/* Move a stone orthogonally */
show_options_orthogonal(Elements, PositionIndex, CurrPlayer):-
   write('Please select the direction of the movement'), nl, 
   write('1- Right'), nl, 
   write('2- Left'), nl, 
   write('3- Up'), nl, 
   write('4- Down'), nl, 
   read(Type), 
   (
        Type = 1 -> move_orthogonal(Elements, PositionIndex, 1, CurrPlayer); 
        Type = 2 -> move_orthogonal(Elements, PositionIndex, -1, CurrPlayer); 
        Type = 3 -> move_orthogonal(Elements, PositionIndex, 4, CurrPlayer); 
        Type = 4 -> move_orthogonal(Elements, PositionIndex, -4, CurrPlayer)
   ). 


/* Move a stone diagonally */
move_diagonal(Elements, PositionIndex, CurrPlayer):-
   write('Please select the direction of the movement'), nl, 
   write('1- Right Up'), nl, 
   write('2- Left Up'), nl, 
   write('3- Right Down'), nl, 
   write('4- Left Down'), nl, 
   read(Type), 
   (
        Type = 1 -> move_diagonally(Elements, PositionIndex, -3, CurrPlayer); 
        Type = 2 -> move_diagonally(Elements, PositionIndex, -5, CurrPlayer); 
        Type = 3 -> move_diagonally(Elements, PositionIndex, 5, CurrPlayer); 
        Type = 4 -> move_diagonally(Elements, PositionIndex, 3, CurrPlayer)
   ). 

move_diagonally(Elements, PositionIndex, Accomulator, CurrPlayer):-
    NewPositionIndex is PositionIndex+Accomulator, 

    /* If the stone is on the first or last column it cannot move to the left(1st) or to the right(last) */
    can_move_diagonally(PositionIndex, Accomulator),

    move_general(Elements, PositionIndex, NewPositionIndex, CurrPlayer).

move_orthogonal(Elements, PositionIndex, Accomulator, CurrPlayer):-
    NewPositionIndex is PositionIndex+Accomulator,

    /* Verify if the New Position is Adjacent to the Previous position */
    verify_adjacent(PositionIndex, NewPositionIndex),

    move_general(Elements, PositionIndex, NewPositionIndex, CurrPlayer).


move_general(Elements, PositionIndex, NewPositionIndex, CurrPlayer):-

    /* Verify if the next position index is valid */
    is_next_position_valid(NewPositionIndex), 

    /* Verify if the position where we are going to go next is taken */ 
    not_taken_rec(Elements, NewPositionIndex), 

    /* Remove the stone from the current position */ 
    replace(Elements,PositionIndex,0,NewElements),

    move_player(NewElements, NewPositionIndex, CurrPlayer).

move_player(Elements, NewPositionIndex, 1):-
    /* Move the stone to its new position */ 
    replace(Elements, NewPositionIndex, p1, NewElements),

    finalize_move(NewElements, CurrPlayer).

move_player(Elements, NewPositionIndex, 2):-
    /* Move the stone to its new position */ 
    replace(Elements, NewPositionIndex, p2, NewElements),

    finalize_move(NewElements, CurrPlayer).

finalize_move(Elements, CurrPlayer):-
    /* Update the board */
    draw_board(Elements),

    /* Change Player Turn */
    change_turn_player(Elements, CurrPlayer).


% ------------------- Drop Stone onto the board -----------------------

drop_stone_menu(Elements, CurrPlayer):-

   /* Insert the stone on the desired position */

   write('Which row do you want to drop your stone (1-4)?'), nl, 
   read(Linha),
   write('Which column do you want to drop your stone (1-4)?'), nl, 
   read(Coluna), 

   /* Verify if it is out of bounds */
   in_bounds_position(Linha, Coluna), 

   /* Position where we are going to insert the stone*/
   Position is (Linha-1)*4+Coluna,
   PositionIndex is Position-1, 

   /* Verify if position is taken */
   not_taken_rec(Elements, PositionIndex),

   drop_stone_currPlayer(Elements, PositionIndex, CurrPlayer).


/* Drops stone depending on the current player */ 
drop_stone_currPlayer(Elements, PositionIndex, 1):-
    /* Update the board -> Criar um novo tabuleiro */
   replace(Elements, PositionIndex, p1, NewElements),
   drop_stone_update(NewElements, 1).

drop_stone_currPlayer(Elements, PositionIndex, 2):-
   /* Update the board -> Criar um novo tabuleiro */
   replace(Elements, PositionIndex, p2, NewElements),
   drop_stone_update(NewElements, 2).

/* Finishes the drop stone action */ 
drop_stone_update(Elements, CurrPlayer):-
   /* Print the new board */
   draw_board(Elements),

   /* Change Player Turn */
   change_turn_player(Elements, CurrPlayer).


% ------------------- Change Player Turn -----------------------

change_turn_player(Elements, 1):-
    /* Player 1 */
    NewPlayer is 1+1, 
    player_turn(Elements, NewPlayer).


change_turn_player(Elements, 2):-
    /* Player 2 */
    NewPlayer is 2-1, 
    player_turn(Elements, NewPlayer).


% ------------------- Verify if the stone belongs to the player (TODO WHEN PlayerVSPlayer Starts to be implemented) -----------------------
belongs_to_player(player, PlayerName).


belongs_to_player_rec([H|T], 0, PlayerName) :- belongs_to_player(H, PlayerName).
belongs_to_player_rec([H|T], Index, PlayerName) :- Index > -1,  I1 is Index-1, belongs_to_player_rec(T, I1, PlayerName).

% ------------------- Verify if stone cannot move diagonally  -----------------------
can_move_diagonally(PositionIndex, Accomulator):-
    (member(PositionIndex,[0, 4, 8, 12]), ((Accomulator == 5) ; (Accomulator == -3)));
    (member(PositionIndex,[3, 7, 11, 15]), ((Accomulator == 3) ; (Accomulator == -5))); 
    (member(PositionIndex,[1, 2, 5, 6, 9, 10, 13, 14])).


% ------------------- Verify if next position is adjacent  -----------------------
verify_adjacent(PositionIndex, NewPositionIndex) :-
    (NewPositionIndex < 4 , NewPositionIndex > -1 , PositionIndex < 4, PositionIndex > -1); 
    (NewPositionIndex < 8, NewPositionIndex > 3, PositionIndex < 8, PositionIndex > 3); 
    (NewPositionIndex < 12, NewPositionIndex > 7, PositionIndex < 12, PositionIndex > 7); 
    (NewPositionIndex < 16, NewPositionIndex > 11, PositionIndex < 16, PositionIndex > 11).


% ------------------- Verify if next position is valid (is not out of bounds) -----------------------
is_next_position_valid(PositionIndex):- PositionIndex < 16, PositionIndex > -1.


% ------------------- Verify if position is in bounds -----------------------
in_bounds_position(Row, Col):- 
    Row < 5, 
    Col < 5, 
    Row > 0, 
    Col > 0.

% ---------------- Verify if the given position is already taken ----------------------------
not_taken(0).

not_taken_rec([H|T], 0) :- not_taken(H).
not_taken_rec([H|T], Index) :- Index > -1,  I1 is Index-1, not_taken_rec(T, I1).

% ---------------- Replace Rule ----------------------------
% replace(+List,+Index,+Value,-NewList). 
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

% ------------------- Start Game -----------------------

game:- board([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],Board),
       get_elements(Board,Elements),
       draw_board(Elements),
       player_turn(Elements, 1).
