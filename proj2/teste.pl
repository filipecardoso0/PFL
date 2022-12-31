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


/* TODO TENTAR COLOCAR AVISOS AO INVES DE EM CASO DE ERRO DETETADO OBRIGAR O JOGADOR A REINCIAR O JOGO */ 
% ------------------- Player Turn Menu -----------------------

% Jumps are mandatory and take precedence over drops and moves.
% Multiple jumps, if possible, are required (no max capture rule)


% ------------------- Player Turn Menu -----------------------

player_turn(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones):-
    /* DEBUG INFO
    write('Player 1 Stones '), write(Player1Stones), nl,
    write('Player 2 Stones '), write(Player2Stones), nl,
    write('Last Played Index: '), write(LastPlayedIndex), nl,
    */
    if(verify_inserted_nearby_player(CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones), player_turn_jump(Elements, CurrPlayer, Player1Stones, Player2Stones), player_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones)).


player_turn_jump(Elements, CurrPlayer, Player1Stones, Player2Stones):-
    write('Player: '), write(CurrPlayer), nl,
    write('Please select an action:'), nl,
    write('1- Jump over an enemy stone.'), nl,
    read(Choice),
    (
        Choice = 1 -> jump_over_stone(Elements, CurrPlayer, Player1Stones, Player2Stones)
    ).

player_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones):-
    write('Player: '), 
    write(CurrPlayer), nl,
    write('Please select an action:'), nl,
    write('1- Drop a stone into an empty cell.'), nl,
    write('2- Move a stone into an adjacent(orthogonal or diagonal empty cell.'), nl,

    read(Choice),
    (
        Choice = 1 -> drop_stone_menu(Elements, CurrPlayer, Player1Stones, Player2Stones); 
        Choice = 2 -> move_stone(Elements, CurrPlayer, Player1Stones, Player2Stones)
    ).

% ------------------- Jump Over Enemy Stone -----------------------
jump_over_stone(Elements, CurrPlayer):- write('Saltar Pedra').

% ------------------- Move Stone -----------------------

move_stone(Elements, CurrPlayer, Player1Stones, Player2Stones):-
    write('Select which Stone do you want to move:'), nl, 
    write('Select the column where the stone is located (1-4):'), nl, 
    read(Col), 
    write('Select the row where the stone is located (1-4): '), nl, 
    read(Row), 

   /* Position index of the stone we are going to move*/
   Position is (Row-1)*4+Col,
   PositionIndex is Position-1, 
 
   /* TODO - Verify if the stone belongs to the player 
   if(belongs_to_player(CurrPlayer, PositionIndex, Player1Stones, Player2Stones) ,move_stone(Elements, CurrPlayer, Player1Stones, Player2Stones)), 
    */

   /* Select the movement type */ 
   movement_selector(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones).

/* Move a stone into an adjacent(orthogonal or diagonal empty cell */
movement_selector(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones):-
    write('Please Select the movement Type: '), nl,
    write('1- Orthogonal'), nl, 
    write('2- Diagonal'), nl, 
    read(Type),
    (
        Type = 1 -> show_options_orthogonal(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones); 
        Type = 2 -> show_options_diagonal(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones)
    ).

/* Move a stone orthogonally */
show_options_orthogonal(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones):-
   write('Please select the direction of the movement'), nl, 
   write('1- Right'), nl, 
   write('2- Left'), nl, 
   write('3- Up'), nl, 
   write('4- Down'), nl, 
   read(Type), 
   (
        Type = 1 -> move_orthogonal(Elements, PositionIndex, 1, CurrPlayer, Player1Stones, Player2Stones); 
        Type = 2 -> move_orthogonal(Elements, PositionIndex, -1, CurrPlayer, Player1Stones, Player2Stones); 
        Type = 3 -> move_orthogonal(Elements, PositionIndex, 4, CurrPlayer, Player1Stones, Player2Stones); 
        Type = 4 -> move_orthogonal(Elements, PositionIndex, -4, CurrPlayer, Player1Stones, Player2Stones)
   ). 


/* Move a stone diagonally */
show_options_diagonal(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones):-
   write('Please select the direction of the movement'), nl, 
   write('1- Right Up'), nl, 
   write('2- Left Up'), nl, 
   write('3- Right Down'), nl, 
   write('4- Left Down'), nl, 
   read(Type), 
   (
        Type = 1 -> move_diagonally(Elements, PositionIndex, -3, CurrPlayer, Player1Stones, Player2Stones); 
        Type = 2 -> move_diagonally(Elements, PositionIndex, -5, CurrPlayer, Player1Stones, Player2Stones); 
        Type = 3 -> move_diagonally(Elements, PositionIndex, 5, CurrPlayer, Player1Stones, Player2Stones); 
        Type = 4 -> move_diagonally(Elements, PositionIndex, 3, CurrPlayer, Player1Stones, Player2Stones)
   ). 

move_diagonally(Elements, PositionIndex, Accomulator, CurrPlayer, Player1Stones, Player2Stones):-
    NewPositionIndex is PositionIndex+Accomulator, 

    /* If the stone is on the first or last column it cannot move to the left(1st) or to the right(last) */
    can_move_diagonally(PositionIndex, Accomulator),

    move_general(Elements, PositionIndex, NewPositionIndex, CurrPlayer, Player1Stones, Player2Stones).

move_orthogonal(Elements, PositionIndex, Accomulator, CurrPlayer, Player1Stones, Player2Stones):-
    NewPositionIndex is PositionIndex+Accomulator,

    /* Verify if the New Position is Adjacent to the Previous position */
    verify_adjacent(PositionIndex, NewPositionIndex),

    move_general(Elements, PositionIndex, NewPositionIndex, CurrPlayer, Player1Stones, Player2Stones).


move_general(Elements, PositionIndex, NewPositionIndex, 1, Player1Stones, Player2Stones):-

    /* Verify if the next position index is valid */
    is_next_position_valid(NewPositionIndex), 

    /* Verify if the position where we are going to go next is taken */ 
    not_taken_rec(Elements, NewPositionIndex), 

    /* Remove the stone from the current position */ 
    replace(Elements,PositionIndex,0,NewElements),
    /* Update Player Stones */ 
    replace(Player1Stones, PositionIndex, 0, NewPlayer1Stones),

    move_player(NewElements, NewPositionIndex, CurrPlayer, NewPlayer1Stones, Player2Stones).

move_general(Elements, PositionIndex, NewPositionIndex, 1, Player1Stones, Player2Stones):-

    /* Verify if the next position index is valid */
    is_next_position_valid(NewPositionIndex), 

    /* Verify if the position where we are going to go next is taken */ 
    not_taken_rec(Elements, NewPositionIndex), 

    /* Remove the stone from the current position */ 
    replace(Elements,PositionIndex,0,NewElements),
    /* Update Player Stones */ 
    replace(Player2Stones, PositionIndex, 0, NewPlayer2Stones),

    move_player(NewElements, NewPositionIndex, CurrPlayer, Player1Stones, NewPlayer2Stones).

move_player(Elements, NewPositionIndex, 1, Player1Stones, Player2Stones):-
    /* Move the stone to its new position */ 
    replace(Elements, NewPositionIndex, p1, NewElements),
    /* Update Player 1 Stones */ 
    replace(Player1Stones, NewPositionIndex, p1, NewPlayer1Stones),

    finish_player_turn(NewElements, CurrPlayer, NewPositionIndex, NewPlayer1Stones, Player2Stones).

move_player(Elements, NewPositionIndex, 2, Player1Stones, Player2Stones):-
    /* Move the stone to its new position */ 
    replace(Elements, NewPositionIndex, p2, NewElements),
    /* Update Player 2 Stones */
    replace(Player2Stones, NewPositionIndex, p1, NewPlayer2Stones),

    finish_player_turn(NewElements, CurrPlayer, NewPositionIndex, NewPlayer1Stones, NewPlayer2Stones).


drop_stone_menu(Elements, CurrPlayer, Player1Stones, Player2Stones):-

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

   drop_stone_currPlayer(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones).


/* Drops stone depending on the current player */ 
drop_stone_currPlayer(Elements, PositionIndex, 1, Player1Stones, Player2Stones):-
    /* Update the board -> Criar um novo tabuleiro */
   replace(Elements, PositionIndex, p1, NewElements),
   /* Update Player Stones */ 
   append(Player1Stones, [PositionIndex], NewPlayer1Stones),

   finish_player_turn(NewElements, 1, PositionIndex, NewPlayer1Stones, Player2Stones).

drop_stone_currPlayer(Elements, PositionIndex, 2, Player1Stones, Player2Stones):-
   /* Update the board -> Criar um novo tabuleiro */
   replace(Elements, PositionIndex, p2, NewElements),
   /* Update Player Stones */ 
   append(Player2Stones, [PositionIndex], NewPlayer2Stones),

   finish_player_turn(NewElements, 2, PositionIndex, Player1Stones, NewPlayer2Stones).

/* Finishes the player turn */ 
finish_player_turn(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones):-
   /* Print the new board */
   draw_board(Elements),

   /* Change Player Turn */
   change_turn_player(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones).

% ------------------- Change Player Turn -----------------------

change_turn_player(Elements, 1, LastPlayedIndex, Player1Stones, Player2Stones):-
    /* Player 1 */
    NewPlayer is 1+1, 
    player_turn(Elements, NewPlayer, LastPlayedIndex, Player1Stones, Player2Stones).


change_turn_player(Elements, 2, LastPlayedIndex, Player1Stones, Player2Stones):-
    /* Player 2 */
    NewPlayer is 2-1, 
    player_turn(Elements, NewPlayer, LastPlayedIndex, Player1Stones, Player2Stones).

% ------------------- Verify if the stone that the player wants to move belongs to him -----------------------

belongs_to_player(1, PositionIndex, Player1Stones, Player2Stones):- member(PositionIndex, Player1Stones).

belongs_to_player(2, PositionIndex, Player1Stones, Player2Stones):- member(PositionIndex, Player2Stones).


% ------------------- Verify if the inserted or moved stone on the previous play is nearby any of the current player stones -----------------------

verify_inserted_nearby_player(1, LastInsertedIndex, Player1Stones, Player2Stones):-
    (Up is LastInsertedIndex-4, member(Up,Player1Stones));
    (Down is LastInsertedIndex+4, member(Down,Player1Stones));
    (Right is LastInsertedIndex+1, member(Right,Player1Stones));
    (Left is LastInsertedIndex+1, member(Left,Player1Stones));
    (RightUp is LastInsertedIndex-3, member(RightUp,Player1Stones));
    (RightDown is LastInsertedIndex+5, member(RightDown,Player1Stones));
    (LeftUp is LastInsertedIndex-5, member(LeftUp,Player1Stones));
    (LeftDown is LastInsertedIndex+3, member(LeftDown,Player1Stones)).

verify_inserted_nearby_player(2, LastInsertedIndex, Player1Stones, Player2Stones):-
    (Up is LastInsertedIndex-4, member(Up,Player2Stones));
    (Down is LastInsertedIndex+4, member(Down,Player2Stones));
    (Right is LastInsertedIndex+1, member(Right,Player2Stones));
    (Left is LastInsertedIndex+1, member(Left,Player2Stones));
    (RightUp is LastInsertedIndex-3, member(RightUp,Player2Stones));
    (RightDown is LastInsertedIndex+5, member(RightDown,Player2Stones));
    (LeftUp is LastInsertedIndex-5, member(LeftUp,Player2Stones));
    (LeftDown is LastInsertedIndex+3, member(LeftDown,Player2Stones)).

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
       player_turn(Elements, 1, 0, [], []).
