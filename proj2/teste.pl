?- use_module(library(system)).
?- use_module(library(random)).

% -------------------Menu and Game Selector----------------------------------
menu :- 
    write('1. Choose Game Mode:'), nl,
    write('2.  Settings:'), nl,
    write('3. Exit.'), nl,
    write('Enter your choice (1-3): '),
    (
        Choice = 1 -> main_menu;
        Choice = 2 -> settings;
        Choice = 3 -> halt
    ).
main_menu:-
    write('Please choose a game mode:'), nl,
    write('1. Computer vs Computer'), nl,
    write('2. Human vs Human'), nl,
    write('3. Human vs Computer mode: Easy'), nl,
    write('Enter your choice (1-3): '),
    read(Choice),
    (
        Choice = 1 -> bot_vs_bot;
        Choice = 2 -> human_vs_human;
        Choice = 3 -> human_vs_easy_bot
    ).
settings:- 
    write('MOVE - On each turn, each player must do one of the following actions'), nl, 
    write('Drop a stone into an empty cell.'),nl,
    write('Move a stone into an adjacent (orthogonal or diagonal) empty cell.'),nl,
    write('Jump over an enemy stone landing on the immediate empty cell, and capturing it.'),nl,
    write('Jumps are mandatory and take precedence over drops and moves.'),nl,
    write('Multiple jumps, if possible, are required (no max capture rule)'),nl,
    write('GOAL - Wins the player that makes an orthogonal or diagonal 3 in-a-row, or captures 6 enemy stones.'), nl,nl,nl,
    write('1. Back to Menu:'), nl,
    write('2. Exit.'), nl,
    write('Enter your choice (1-2): '),
    (
        Choice = 1 -> main_menu;
        Choice = 2 -> halt
    ).
bot_vs_bot:- 
    write('Starting Computer vs Computer game...'),
    play(Bot,Bot).

human_vs_human:- 
    write('Starting Human vs Human game...'),
    play(Player,Player).

human_vs_easy_bot:-
    write('Starting Human vs Bot game...'),
    play(Player,Bot).

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

player_turn(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    /* DEBUG INFO */
    write('Player 1 Stones '), write(Player1Stones), nl,
    write('Player 2 Stones '), write(Player2Stones), nl,
    write('Player 1 Captured Stones '), write(CapturedStones1), nl,
    write('Player 2 Captured Stones '), write(CapturedStones2), nl,
    write('Player 1 Deployed Stones '), write(Stone1Num), nl, 
    write('Player 2 Deployed Stones '), write(Stone2Num), nl, 
    write('Last Played Index: '), write(LastPlayedIndex), nl,
  
    verify_inserted_nearby_player(CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones) -> player_turn_jump(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType) ; 
                                                                                                player_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).                                                                                   


player_turn_jump(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    write('Player: '), write(CurrPlayer), nl,
    write('Please select an action:'), nl,
    write('1- Jump over an enemy stone.'), nl,
    read(Choice),
    (
        Choice = 1 -> jump_over_stone(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)
    ).
 
% ----------------- DONT DISPLAY MOVE ACTION IF USER HAS NOT ANY STONE ON THE ARENA ----------------- 

player_turn_DropOrMove(Elements, 1, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, 8, Stone2Num, GameType):-

    write('Player: '), 
    write(1), nl,
    write('Please select an action:'), nl,
    write('1- Drop a stone into an empty cell.'), nl,

    read(Choice),
    (
        Choice = 1 -> drop_stone_menu(Elements, 1, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, 8, Stone2Num, GameType)
    ).

player_turn_DropOrMove(Elements, 2, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 8, GameType):-

    write('Player: '), 
    write(2), nl,
    write('Please select an action:'), nl,
    write('1- Drop a stone into an empty cell.'), nl,

    read(Choice),
    (
        Choice = 1 -> drop_stone_menu(Elements, 2, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 8, GameType)
    ).

% ----------------- DONT DISPLAY DROP A STONE ACTION IF USER HAS ALREADY DEPLOYED ALL HIS STONES ----------------- 

player_turn_DropOrMove(Elements, 1, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 0, GameType):-

    write('Player: '), 
    write(1), nl,
    write('Please select an action:'), nl,
    write('1- Move a stone into an adjacent(orthogonal or diagonal empty cell.'), nl,

    read(Choice),
    (
        Choice = 1 -> move_stone(Elements, 1, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 0, GameType)
    ).

player_turn_DropOrMove(Elements, 2, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 0, GameType):-

    write('Player: '), 
    write(2), nl,
    write('Please select an action:'), nl,
    write('1- Move a stone into an adjacent(orthogonal or diagonal empty cell.'), nl,

    read(Choice),
    (
        Choice = 1 -> move_stone(Elements, 2, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 0, GameType)
    ).

% ----------------- DROP OR MOVE DEFAULT DISPLAY MENU ----------------- 

player_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    write('Player: '), 
    write(CurrPlayer), nl,
    write('Please select an action:'), nl,
    write('1- Drop a stone into an empty cell.'), nl,
    write('2- Move a stone into an adjacent(orthogonal or diagonal empty cell.'), nl,

    read(Choice),
    (
        Choice = 1 -> drop_stone_menu(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType); 
        Choice = 2 -> move_stone(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)
    ).

% ------------------- Jump Over Enemy Stone -----------------------

jump_over_stone(Elements, 2, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
/* Saber as pedras que estão próximas daquela que está perto da nossa */ 
   
    (Up is LastPlayedIndex-4, member(Up,Player2Stones) -> Stone1Index is Up; Stone1Index is -1),
    (Down is LastPlayedIndex+4, member(Down,Player2Stones) -> Stone2Index is Down; Stone2Index is -1),
    (Right is LastPlayedIndex+1, member(Right,Player2Stones) -> Stone3Index is Right; Stone3Index is -1),
    (Left is LastPlayedIndex-1, member(Left,Player2Stones) -> Stone4Index is Left; Stone4Index is -1),
    (RightUp is LastPlayedIndex-3, member(RightUp,Player2Stones) -> Stone5Index is RightUp; Stone5Index is -1),
    (RightDown is LastPlayedIndex+5, member(RightDown,Player2Stones) -> Stone6Index is RightDown; Stone6Index is -1),
    (LeftUp is LastPlayedIndex-5, member(LeftUp,Player2Stones) -> Stone7Index is LeftUp; Stone7Index is -1),
    (LeftDown is LastPlayedIndex+3, member(LeftDown,Player2Stones) -> Stone8Index is LeftDown; Stone8Index is -1),


    /* Ask the player which stone we wants to move */
    write('Please select a stone to perform the jump (Row, Col): '), nl,

    output_jump_option_aux(Stone1Index, 1, 2), 
    output_jump_option_aux(Stone2Index, 2, 2), 
    output_jump_option_aux(Stone3Index, 3, 2), 
    output_jump_option_aux(Stone4Index, 4, 2), 
    output_jump_option_aux(Stone5Index, 5, 2), 
    output_jump_option_aux(Stone6Index, 6, 2), 
    output_jump_option_aux(Stone7Index, 7, 2), 
    output_jump_option_aux(Stone8Index, 8, 2),


    Jumpdirection1 is (Stone1Index-LastPlayedIndex)*(-1),
    Jumpdirection2 is (Stone2Index-LastPlayedIndex)*(-1), 
    Jumpdirection3 is (Stone3Index-LastPlayedIndex)*(-1),
    Jumpdirection4 is (Stone4Index-LastPlayedIndex)*(-1), 
    Jumpdirection5 is (Stone5Index-LastPlayedIndex)*(-1), 
    Jumpdirection6 is (Stone6Index-LastPlayedIndex)*(-1), 
    Jumpdirection7 is (Stone7Index-LastPlayedIndex)*(-1), 

    read(Stone),
    (
        Stone = 1 -> make_jump(Elements, 2, Player1Stones, Player2Stones, Jumpdirection1, Stone1Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType); 
        Stone = 2 -> make_jump(Elements, 2, Player1Stones, Player2Stones, Jumpdirection2, Stone2Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 3 -> make_jump(Elements, 2, Player1Stones, Player2Stones, Jumpdirection3, Stone3Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 4 -> make_jump(Elements, 2, Player1Stones, Player2Stones, Jumpdirection4, Stone4Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 5 -> make_jump(Elements, 2, Player1Stones, Player2Stones, Jumpdirection5, Stone5Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 6 -> make_jump(Elements, 2, Player1Stones, Player2Stones, Jumpdirection6, Stone6Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 7 -> make_jump(Elements, 2, Player1Stones, Player2Stones, Jumpdirection7, Stone7Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)
    ).

check_jump_oportunities(Elements,1, LastPlayedIndex, Player1Stones, Player2Stones):-
    Up is LastPlayedIndex-4, member(Up,Player2Stones);
    Down is LastPlayedIndex+4, member(Down,Player2Stones);
    Right is LastPlayedIndex+1, member(Right,Player2Stones);
    Left is LastPlayedIndex-1, member(Left,Player2Stones);
    RightUp is LastPlayedIndex-3, member(RightUp,Player2Stones);
    RightDown is LastPlayedIndex+5, member(RightDown,Player2Stones);
    LeftUp is LastPlayedIndex-5, member(LeftUp,Player2Stones);
    LeftDown is LastPlayedIndex+3, member(LeftDown,Player2Stones).

check_jump_oportunities(Elements,2, LastPlayedIndex, Player1Stones, Player2Stones):-
    Up is LastPlayedIndex-4, member(Up,Player1Stones);
    Down is LastPlayedIndex+4, member(Down,Player1Stones);
    Right is LastPlayedIndex+1, member(Right,Player1Stones);
    Left is LastPlayedIndex-1, member(Left,Player1Stones);
    RightUp is LastPlayedIndex-3, member(RightUp,Player1Stones);
    RightDown is LastPlayedIndex+5, member(RightDown,Player1Stones);
    LeftUp is LastPlayedIndex-5, member(LeftUp,Player1Stones);
    LeftDown is LastPlayedIndex+3, member(LeftDown,Player1Stones).




jump_over_stone(Elements, 1, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
/* Saber as pedras que estão próximas daquela que está perto da nossa */ 
   
    (Up is LastPlayedIndex-4, member(Up,Player1Stones) -> Stone1Index is Up; Stone1Index is -1),
    (Down is LastPlayedIndex+4, member(Down,Player1Stones) -> Stone2Index is Down; Stone2Index is -1),
    (Right is LastPlayedIndex+1, member(Right,Player1Stones) -> Stone3Index is Right; Stone3Index is -1),
    (Left is LastPlayedIndex-1, member(Left,Player1Stones) -> Stone4Index is Left; Stone4Index is -1),
    (RightUp is LastPlayedIndex-3, member(RightUp,Player1Stones) -> Stone5Index is RightUp; Stone5Index is -1),
    (RightDown is LastPlayedIndex+5, member(RightDown,Player1Stones) -> Stone6Index is RightDown; Stone6Index is -1),
    (LeftUp is LastPlayedIndex-5, member(LeftUp,Player1Stones) -> Stone7Index is LeftUp; Stone7Index is -1),
    (LeftDown is LastPlayedIndex+3, member(LeftDown,Player1Stones) -> Stone8Index is LeftDown; Stone8Index is -1),
  

    /* Ask the player which stone we wants to move */
    write('Please select a stone to perform the jump (Row, Col): '), nl,

    output_jump_option_aux(Stone1Index, 1, 1), 
    output_jump_option_aux(Stone2Index, 2, 1), 
    output_jump_option_aux(Stone3Index, 3, 1), 
    output_jump_option_aux(Stone4Index, 4, 1), 
    output_jump_option_aux(Stone5Index, 5, 1), 
    output_jump_option_aux(Stone6Index, 6, 1), 
    output_jump_option_aux(Stone7Index, 7, 1), 
    output_jump_option_aux(Stone8Index, 8, 1),


    Jumpdirection1 is (Stone1Index-LastPlayedIndex)*(-1),
    Jumpdirection2 is (Stone2Index-LastPlayedIndex)*(-1), 
    Jumpdirection3 is (Stone3Index-LastPlayedIndex)*(-1),
    Jumpdirection4 is (Stone4Index-LastPlayedIndex)*(-1), 
    Jumpdirection5 is (Stone5Index-LastPlayedIndex)*(-1), 
    Jumpdirection6 is (Stone6Index-LastPlayedIndex)*(-1), 
    Jumpdirection7 is (Stone7Index-LastPlayedIndex)*(-1), 

    read(Stone),
    (
        Stone = 1 -> make_jump(Elements, 1, Player1Stones, Player2Stones, Jumpdirection1, Stone1Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType); 
        Stone = 2 -> make_jump(Elements, 1, Player1Stones, Player2Stones, Jumpdirection2, Stone2Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 3 -> make_jump(Elements, 1, Player1Stones, Player2Stones, Jumpdirection3, Stone3Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 4 -> make_jump(Elements, 1, Player1Stones, Player2Stones, Jumpdirection4, Stone4Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 5 -> make_jump(Elements, 1, Player1Stones, Player2Stones, Jumpdirection5, Stone5Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameTypes);
        Stone = 6 -> make_jump(Elements, 1, Player1Stones, Player2Stones, Jumpdirection6, Stone6Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
        Stone = 7 -> make_jump(Elements, 1, Player1Stones, Player2Stones, Jumpdirection7, Stone7Index, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)
    ).

output_jump_option_aux(Index, Num, CurrPlayer):-

    Row is Index // 4, 
    Column is Index mod 4, 

    if(Index > -1 , output_jump_option_final(Index, Num, CurrPlayer, Row, Column), true).

output_jump_option_final(Index, Num, CurrPlayer, Row, Column):-
    write(Num), write('- '), write('Player('), write(CurrPlayer), write(') -> Stone @ ('), write(Row), write(','), write(Column), write(')'), nl.

make_jump(Elements, CurrPlayer, Player1Stones, Player2Stones, Jumpdirection, StartPoint, StoneToBeDeleted, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-

    Attempt1 is StartPoint+Jumpdirection+Jumpdirection,
    
    if(is_next_position_valid(Attempt1), finalize_make_jump(Elements, CurrPlayer, StartPoint, Player1Stones, Player2Stones, Attempt1, StoneToBeDeleted, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), player_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)).


finalize_make_jump(Elements, 1, StartPoint, Player1Stones, Player2Stones, NewStonePosition, StoneToBeDeleted, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-

    /* Atualizar a Posição da Peça */ 
    replace(Elements, StartPoint, 0, NewElements),
    replace(NewElements, NewStonePosition, 1, UpdatedElements),

    /* Retirar a pedra comida do tabuleiro */
    replace(UpdatedElements, StoneToBeDeleted, 0, FinalElements),

    /* Atualizar o Vetor de Pedras de Ambos os Players */
    append(Player1Stones, [NewStonePosition], NewPlayer1Stones),
    delete(StartPoint, NewPlayer1Stones, FinalPlayer1Stones),
    delete(StoneToBeDeleted, Player2Stones, NewPlayer2Stones),

    NewCapturedStones1 is CapturedStones1 + 1,
    if(check_jump_oportunities(FinalElements,1,StartPoint,FinalPlayer1Stones, NewPlayer2Stones),jump_over_stone(FinalElements,1,StartPoint,FinalPlayer1Stones, NewPlayer2Stones, NewCapturedStones1, CapturedStones2,Stone1Num,Stone2Num, GameType),finish_player_turn(FinalElements, 1, NewStonePosition, FinalPlayer1Stones, NewPlayer2Stones, NewCapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)).


finalize_make_jump(Elements, 2, StartPoint, Player1Stones, Player2Stones, NewStonePosition, StoneToBeDeleted, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-


    /* Atualizar a Posição da Peça */ 
    replace(Elements, StartPoint, 0, NewElements),
    replace(NewElements, NewStonePosition, 2, UpdatedElements),

    /* Retirar a pedra comida do tabuleiro */
    replace(UpdatedElements, StoneToBeDeleted, 0, FinalElements),

    /* Atualizar o Vetor de Pedras de Ambos os Players */
    append(Player2Stones, [NewStonePosition], NewPlayer2Stones),
    delete(StartPoint, NewPlayer2Stones, FinalPlayer2Stones),
    delete(StoneToBeDeleted, Player1Stones, NewPlayer1Stones),
    
    /* TODO Incrementar a contagem de Pedras comidas do Player*/
    NewCapturedStones2 is CapturedStones2 + 1,

    /* Finalizar o movement -> Update do estado do tabuleiro */
   if(check_jump_oportunities(FinalElements,2,StartPoint,NewPlayer1Stones, FinalPlayer2Stones),jump_over_stone(FinalElements,2,StartPoint, NewPlayer1Stones, FinalPlayer2Stones, CapturedStones1, NewCapturedStones2,Stone1Num,Stone2Num, GameType),finish_player_turn(FinalElements, 1, NewStonePosition, NewPlayer1Stones, FinalPlayer2Stones, CapturedStones1, NewCapturedStones2, Stone1Num, Stone2Num, GameType)).

% ------------------- Move Stone -----------------------

move_stone(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    write('Select which Stone do you want to move:'), nl, 
    write('Select the row where the stone is located (1-4):'), nl, 
    read(Row), 
    write('Select the col where the stone is located (1-4): '), nl, 
    read(Col), 

   /* Position index of the stone we are going to move*/
   Position is (Row-1)*4+Col,
   PositionIndex is Position-1, 
 
   /* TODO - Verify if the stone belongs to the player 
   if(belongs_to_player(CurrPlayer, PositionIndex, Player1Stones, Player2Stones) ,move_stone(Elements, CurrPlayer, Player1Stones, Player2Stones)), 
    */

   /* Select the movement type */ 
   movement_selector(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).

/* Move a stone into an adjacent(orthogonal or diagonal empty cell */
movement_selector(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    write('Please Select the movement Type: '), nl,
    write('1- Orthogonal'), nl, 
    write('2- Diagonal'), nl, 
    read(Type),
    (
        Type = 1 -> show_options_orthogonal(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType); 
        Type = 2 -> show_options_diagonal(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)
    ).

/* Move a stone orthogonally */
show_options_orthogonal(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
   write('Please select the direction of the movement'), nl, 
   write('1- Right'), nl, 
   write('2- Left'), nl, 
   write('3- Up'), nl, 
   write('4- Down'), nl, 
   read(Type), 
   (
        Type = 1 -> move_orthogonal(Elements, PositionIndex, 1, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType); 
        Type = 2 -> move_orthogonal(Elements, PositionIndex, -1, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType); 
        Type = 3 -> move_orthogonal(Elements, PositionIndex, -4, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType); 
        Type = 4 -> move_orthogonal(Elements, PositionIndex, 4, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)
   ). 


/* Move a stone diagonally */
show_options_diagonal(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
   write('Please select the direction of the movement'), nl, 
   write('1- Right Up'), nl, 
   write('2- Left Up'), nl, 
   write('3- Right Down'), nl, 
   write('4- Left Down'), nl, 
   read(Type), 
   (
        Type = 1 -> move_diagonally(Elements, PositionIndex, -3, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num); 
        Type = 2 -> move_diagonally(Elements, PositionIndex, -5, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num); 
        Type = 3 -> move_diagonally(Elements, PositionIndex, 5, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num); 
        Type = 4 -> move_diagonally(Elements, PositionIndex, 3, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num)
   ). 

move_diagonally(Elements, PositionIndex, Accomulator, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    NewPositionIndex is PositionIndex+Accomulator, 

    /* If the stone is on the first or last column it cannot move to the left(1st) or to the right(last) */
    can_move_diagonally(PositionIndex, Accomulator),

    move_general(Elements, PositionIndex, NewPositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).

move_orthogonal(Elements, PositionIndex, Accomulator, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    NewPositionIndex is PositionIndex+Accomulator,

    /* Verify if the New Position is Adjacent to the Previous position */
    verify_adjacent(PositionIndex, NewPositionIndex),

    move_general(Elements, PositionIndex, NewPositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).


move_general(Elements, PositionIndex, NewPositionIndex, 1, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-

    /* Verify if the next position index is valid */
    is_next_position_valid(NewPositionIndex), 

    /* Verify if the position where we are going to go next is taken */ 
    not_taken_rec(Elements, NewPositionIndex), 

    /* Remove the stone from the current position -> Update Board */ 
    replace(Elements,PositionIndex,0,NewElements),

    /* Move the stone to its new position -> Update Board */ 
    replace(NewElements, NewPositionIndex, 1, FinalElements),

    /* Update Player 1 Stones */ 
    append(Player1Stones, [NewPositionIndex], NewPlayer1Stones),
    delete(PositionIndex, NewPlayer1Stones, FinalPlayer1Stones),

    finish_player_turn(FinalElements, 1, NewPositionIndex, FinalPlayer1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).


move_general(Elements, PositionIndex, NewPositionIndex, 2, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-

    /* Verify if the next position index is valid */
    is_next_position_valid(NewPositionIndex), 

    /* Verify if the position where we are going to go next is taken */ 
    not_taken_rec(Elements, NewPositionIndex), 

    /* Remove the stone from the current position -> Update Board */ 
    replace(Elements,PositionIndex,0,NewElements),

    /* Move the stone to its new position -> Update Board */ 
    replace(NewElements, NewPositionIndex, 2, FinalElements),

    /* Update Player 2 Stones */ 
    append(Player2Stones, [NewPositionIndex], NewPlayer2Stones),
    delete(PositionIndex, NewPlayer2Stones, FinalPlayer2Stones),

    finish_player_turn(FinalElements, 2, NewPositionIndex, Player1Stones, FinalPlayer2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).


drop_stone_menu(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-

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

   drop_stone_currPlayer(Elements, PositionIndex, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).


/* Drops stone depending on the current player */ 
drop_stone_currPlayer(Elements, PositionIndex, 1, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    /* Update the board -> Criar um novo tabuleiro */
   replace(Elements, PositionIndex, 1, NewElements),
   /* Update Player Stones */ 
   append(Player1Stones, [PositionIndex], NewPlayer1Stones),
   /* Update Player Stones Number*/
   NewStone1Num is Stone1Num-1,

   finish_player_turn(NewElements, 1, PositionIndex, NewPlayer1Stones, Player2Stones, CapturedStones1, CapturedStones2, NewStone1Num, Stone2Num, GameType).

drop_stone_currPlayer(Elements, PositionIndex, 2, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
   /* Update the board -> Criar um novo tabuleiro */
   replace(Elements, PositionIndex, 2, NewElements),
   /* Update Player Stones */ 
   append(Player2Stones, [PositionIndex], NewPlayer2Stones),
   /* Update Player Stones Number*/
   NewStone2Num is Stone2Num-1,

   finish_player_turn(NewElements, 2, PositionIndex, Player1Stones, NewPlayer2Stones, CapturedStones1, CapturedStones2, Stone1Num, NewStone2Num, GameType).

/* Finishes the player turn */ 
finish_player_turn(Elements, 1, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
   /* Print the new board */
   draw_board(Elements),

   /* Verify if player 1 won */
   if(verify_win_state(Elements, 1, CapturedStones1), true, change_turn_player(Elements, 1, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)).


finish_player_turn(Elements, 2, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
   /* Print the new board */
   draw_board(Elements),

   /* Verify if player 2 won */
   if(verify_win_state(Elements, 2, CapturedStones2), true, change_turn_player(Elements, 2, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)).

% ------------------- Change Player Turn (Based on GameType) -----------------------

                    % ------------------- GameType 1 - PlayerVSPlayer -----------------------

change_turn_player(Elements, 1, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num,1):-
    /* Player 1 */
    NewPlayer is 1+1, 
    player_turn(Elements, NewPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num,1).


change_turn_player(Elements, 2, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 1):-
    /* Player 2 */
    NewPlayer is 2-1, 
    player_turn(Elements, NewPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 1).


                    % ------------------- GameType 2 - PlayerVSComputer -----------------------
change_turn_player(Elements, 1, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num,2):-
    /* Player 1 */
    NewPlayer is 1+1, 
    bot_turn(Elements, NewPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 2).

change_turn_player(Elements, 2, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num,2):-
    /* Player 2 */
    NewPlayer is 2-1, 
    player_turn(Elements, NewPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 2).


                    % ------------------- GameType 3 - ComputerVSComputer -----------------------
change_turn_player(Elements,1,LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2,Stone1Num, Stone2Num,3):-
    /* Player 1 */
    NewPlayer is 1+1, 
    bot_turn(Elements, NewPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 3).

change_turn_player(Elements,1,LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2,Stone1Num, Stone2Num,3):-
    /* Player 2 */
    NewPlayer is 2-1, 
    bot_turn(Elements, NewPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 3).

% ------------------- Verify if the stone that the player wants to move belongs to him -----------------------

belongs_to_player(1, PositionIndex, Player1Stones, Player2Stones):- member(PositionIndex, Player1Stones).

belongs_to_player(2, PositionIndex, Player1Stones, Player2Stones):- member(PositionIndex, Player2Stones).


% ------------------- Verify if the inserted or moved stone on the previous play is nearby any of the current player stones -----------------------

verify_inserted_nearby_player(1, LastInsertedIndex, Player1Stones, Player2Stones):-
    (Up is LastInsertedIndex-4, member(Up,Player1Stones));
    (Down is LastInsertedIndex+4, member(Down,Player1Stones));
    (Right is LastInsertedIndex+1, member(Right,Player1Stones));
    (Left is LastInsertedIndex-1, member(Left,Player1Stones));
    (RightUp is LastInsertedIndex-3, member(RightUp,Player1Stones));
    (RightDown is LastInsertedIndex+5, member(RightDown,Player1Stones));
    (LeftUp is LastInsertedIndex-5, member(LeftUp,Player1Stones));
    (LeftDown is LastInsertedIndex+3, member(LeftDown,Player1Stones)).

verify_inserted_nearby_player(2, LastInsertedIndex, Player1Stones, Player2Stones):-
    (Up is LastInsertedIndex-4, member(Up,Player2Stones));
    (Down is LastInsertedIndex+4, member(Down,Player2Stones));
    (Right is LastInsertedIndex+1, member(Right,Player2Stones));
    (Left is LastInsertedIndex-1, member(Left,Player2Stones));
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
    (NewPositionIndex < 16, NewPositionIndex > 11, PositionIndex < 16, PositionIndex > 11);
    ((NewPositionIndex - PositionIndex) > 3, (NewPositionIndex - PositionIndex) < 5); 
    ((PositionIndex - NewPositionIndex) > 3, (PositionIndex - NewPositionIndex) < 5).
    

% ------------------- Verify if next position is valid (is not out of bounds) -----------------------
is_next_position_valid(PositionIndex):- PositionIndex < 16, PositionIndex > -1.

% ------------------- Verify if position is in bounds -----------------------
in_bounds_position(Row, Col):- 
    Row < 5, 
    Col < 5, 
    Row > 0, 
    Col > 0.

% ---------------- Remove an element from the list ----------------------------
delete(X, [X|Tail], Tail).
delete(X, [Y|Tail], [Y|Tail1]) :- delete(X, Tail, Tail1).

% ---------------- Verify if the given position is already taken ----------------------------
occupied(p1).
occupied(p2).

occupied_rec([H|T], 0) :- occupied(H).
occupied_rec([H|T], Index) :- Index > -1,  I1 is Index-1, occupied_rec(T, I1).

% ---------------- Replace Rule ----------------------------
% replace(+List,+Index,+Value,-NewList). 
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

% ---------------- Verify if player won ----------------------------

verify_win_state(Elements, CurrPlayer, CapturedStones):- 
    WinBoards = [
                    /* ROW BOARD WIN */
                    [CurrPlayer, CurrPlayer, CurrPlayer, _, _, _, _, _, _, _, _, _, _, _, _, _],
                    [_, CurrPlayer, CurrPlayer, CurrPlayer, _, _, _, _, _, _, _, _, _, _, _, _],
                    [_, _, _, _, CurrPlayer, CurrPlayer, CurrPlayer, _, _, _, _, _, _, _, _, _],
                    [_, _, _, _, _, CurrPlayer, CurrPlayer, CurrPlayer, _, _, _, _, _, _, _, _],
                    [_, _, _, _, _, _, _, _, CurrPlayer, CurrPlayer, CurrPlayer, _, _, _, _, _],
                    [_, _, _, _, _, _, _, _, _, CurrPlayer, CurrPlayer, CurrPlayer, _, _, _, _],
                    [_, _, _, _, _, _, _, _, _, _, _, _, CurrPlayer, CurrPlayer, CurrPlayer, _],
                    [_, _, _, _, _, _, _, _, _, _, _, _, _, CurrPlayer, CurrPlayer, CurrPlayer],
                    /* COLUMN BOARD WIN */
                    [CurrPlayer, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, _, _, _, _],
                    [_, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _],
                    [_, CurrPlayer, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, _, _, _],
                    [_, _, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _],
                    [_, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, _, _],
                    [_, _, _, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _],
                    [_, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, _],
                    [_, _, _, _, _, _, _, CurrPlayer, _, _, _, CurrPlayer, _, _, _, CurrPlayer],
                    /* DIAGONAL BOARD WIN */
                    [CurrPlayer, _, _, _, _, CurrPlayer, _, _, _, _, CurrPlayer, _, _, _, _, _],
                    [_, _, _, _, _, CurrPlayer, _, _, _, _, CurrPlayer, _, _, _, _, CurrPlayer],
                    [_, CurrPlayer, _, _, _, _, CurrPlayer, _, _, _, _, CurrPlayer, _, _, _, _],
                    [_, _, _, _, CurrPlayer, _, _, _, _, CurrPlayer, _, _, _, _, CurrPlayer, _],
                    [_, _, _, CurrPlayer, _, _, CurrPlayer, _, _, CurrPlayer, _, _, _, _, _, _],
                    [_, _, _, _, _, _, CurrPlayer, _, _, CurrPlayer, _, _, CurrPlayer, _, _, _],
                    [_, _, CurrPlayer, _, _, CurrPlayer, _, _, CurrPlayer, _, _, _, _, _, _, _],
                    [_, _, _, _, _, _, _, CurrPlayer, _, _, CurrPlayer, _, _, CurrPlayer, _, _]
                ],

    if(member(Elements, WinBoards), output_win_screen(CurrPlayer), false),
    if(CapturedStones == 6, output_win_screen(CurrPlayer), false).

output_win_screen(CurrPlayer):-
    write('----------------------------------'),nl,
    write('-------------- Player '), write(CurrPlayer), write(' Won --------------'), nl,
    write('----------------------------------'), nl,
    write('Closing game in: '), nl,
    sleep(1),
    write('5 '), nl,
    sleep(1),
    write('4 '), nl,
    sleep(1),
    write('3 '), nl,
    sleep(1),
    write('2 '), nl,
    sleep(1),
    write('1 '), nl,
    nl,
    halt.   

% ---------------- Verify if the given position is already taken ----------------------------
not_taken(0).

not_taken_rec([H|T], 0) :- not_taken(H).
not_taken_rec([H|T], Index) :- Index > -1,  I1 is Index-1, not_taken_rec(T, I1).


% ---------------------------------------------- AI FUNCTIONS AREA ------------------------------------------------------

% ------------------- BOT TURN MANAGER -------------------
bot_turn(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    /* DEBUG INFO */
    write('Player 1 Stones '), write(Player1Stones), nl,
    write('Player 2 Stones '), write(Player2Stones), nl,
    write('Player 1 Captured Stones '), write(CapturedStones1), nl,
    write('Player 2 Captured Stones '), write(CapturedStones2), nl,
    write('Player 1 Deployed Stones '), write(Stone1Num), nl, 
    write('Player 2 Deployed Stones '), write(Stone2Num), nl, 
    write('Last Played Index: '), write(LastPlayedIndex), nl,
  
    verify_inserted_nearby_player(CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones) -> bot_jump_over_stone(Elements, CurrPlayer, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType); 
                                                                                                bot_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType). 
      

% ------------------- BOT MOVEMENT SELECTOR FOR GameType 2 -------------------

/* IF STONE COUNT == 0 -> ONLY MOVE */ 
bot_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 0, 2):-
    /* MOVE STONE */
    search_forPiece_rec(Elements, [], 0, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 0, 2).
    
/* IF STONE COUNT == MAX -> ONLY DROP */ 
bot_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 8, 2):-
    /* DROP STONE */
    search_for0_rec(Elements, [], 0, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, 8, 2).

/* ELSE CHOOSE BETWEEN DROP AND MOVE */
bot_turn_DropOrMove(Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 2):-

    % Generate a random movement
    random_member(RandomVal, [1, 2]), 


    /* DROP STONE */
    RandomVal == 1 -> search_for0_rec(Elements, [], 0, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
    /* MOVE STONE */
    RandomVal == 2 -> search_forPiece_rec(Elements, [], 0, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).

% ------------------- AI DROP ---------------------------
/* Depois no vetor escolher um numero random */ 

/* Ver todos os indices do board que estão a zero e coloca-los num vetor -> Call function search_for0_rec(Elements, [], 0) */ 

search_for0_rec([], NewList, Index, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):- generate_drop_random(NewList, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).
search_for0_rec([0|T], NewList, Index, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType) :- append(NewList, [Index], FinalNewList), I1 is Index+1, search_for0_rec(T, FinalNewList, I1, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).
search_for0_rec([H|T], NewList, Index, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType) :- I1 is Index+1, search_for0_rec(T, NewList, I1, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).

% ------------------- DROP STONE : PLAYER VS BOT ---------------------------

generate_drop_random(NewList, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 2):-
        
    random_member(RandomVal, NewList),

    /* Update AI Stones List */ 
    append(Player2Stones, [RandomVal], NewPlayer2Stones),

    /* Update AI Stones Count */ 
    NewStone2Num is Stone2Num-1, 

    /* Update Elements List */
    replace(Elements, RandomVal, 2, NewElements),
    
    /* Change Player Turn */ 
    finish_player_turn(NewElements, CurrPlayer, RandomVal, Player1Stones, NewPlayer2Stones, CapturedStones1, CapturedStones2, Stone1Num, NewStone2Num, 2).

% ------------------- AI MOVE -------------------
/* Ver todos os sitios do board que têm uma peça */ 
/* Verifica-se as adjacências (se o espaço "ao lado" está vazio) e coloca-se num vetor */

% ------------------- AI MOVE : PLAYER VS BOT -------------------

generate_move_random(Index, NewList, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 2):-

    random_member(RandomVal, NewList),

    /* Update AI Stones List -> MODIFY THIS LATER ON  */ 
    append(Player2Stones, [RandomVal], NewPlayer2Stones),
    delete(Index, NewPlayer2Stones, FinalPlayer2Stones),

    /* Update Elements List */ 
    replace(Elements, Index, 0, NewElements), 
    replace(NewElements, RandomVal, 2, FinalElements),

    /* Change Player Turn */ 
    finish_player_turn(FinalElements, CurrPlayer, RandomVal, Player1Stones, FinalPlayer2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, 2).

search_for_adjacent_pieces(Index, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    Up is Index-4,
    Down is Index+4,
    Right is Index+1, 
    Left is Index-1,
    RightUp is Index-3,
    RightDown is Index+5,
    LeftUp is Index-5,
    LeftDown is Index+3,
    (not_taken_rec(Elements, Up) -> append([], [Up], Adjacent1); true),
    (not_taken_rec(Elements, Down) -> append([], [Down], Adjacent2); true),
    (not_taken_rec(Elements, Right) -> append([], [Right], Adjacent3); true),
    (not_taken_rec(Elements, Left) -> append([], [Left], Adjacent4); true),
    (not_taken_rec(Elements, RightUp) -> append([], [RightUp], Adjacent5); true),
    (not_taken_rec(Elements, RightDown) -> append([], [RightDown], Adjacent6); true),
    (not_taken_rec(Elements, LeftUp) -> append([], [LeftUp], Adjacent7); true),
    (not_taken_rec(Elements, LeftDown) -> append([], [LeftDown], Adjacent8); true),
    
    append(Adjacent1, Adjacent2, NewList),
    append(NewList, Adjacent3, NewList1), 
    append(NewList1, Adjacent4, NewList2),  
    append(NewList2, Adjacent5, NewList3), 
    append(NewList3, Adjacent6, NewList4), 
    append(NewList4, Adjacent7, NewList5), 
    append(NewList5, Adjacent8, NewList6),
    generate_move_random(Index, NewList6, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).

get_piece_adjacent_elements([H|T], Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):- 
    search_for_adjacent_pieces(H, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).

/* Searches for the adjency list of a certain piece
   Call it like that -> search_forPiece_rec(Elements, [], 0, Elements) */ 
search_forPiece_rec([], NewList, Index, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):- get_piece_adjacent_elements(NewList, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).
search_forPiece_rec([CurrPlayer|T], NewList, Index, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType) :- 
    append(NewList, [Index], FinalNewList), 
    I1 is Index+1, 
    search_forPiece_rec(T, FinalNewList, I1, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).
search_forPiece_rec([H|T], NewList, Index, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType) :- I1 is Index+1, search_forPiece_rec(T, NewList, I1, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).

% ------------------- BOT JUMP - GAME MODE 2 ------------------- %


bot_jump_over_stone(Elements, 2, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
/* Saber as pedras que estão próximas daquela que está perto da nossa */ 
   
    (Up is LastPlayedIndex-4, member(Up,Player2Stones) -> Stone1Index is Up; Stone1Index is -1),
    (Down is LastPlayedIndex+4, member(Down,Player2Stones) -> Stone2Index is Down; Stone2Index is -1),
    (Right is LastPlayedIndex+1, member(Right,Player2Stones) -> Stone3Index is Right; Stone3Index is -1),
    (Left is LastPlayedIndex-1, member(Left,Player2Stones) -> Stone4Index is Left; Stone4Index is -1),
    (RightUp is LastPlayedIndex-3, member(RightUp,Player2Stones) -> Stone5Index is RightUp; Stone5Index is -1),
    (RightDown is LastPlayedIndex+5, member(RightDown,Player2Stones) -> Stone6Index is RightDown; Stone6Index is -1),
    (LeftUp is LastPlayedIndex-5, member(LeftUp,Player2Stones) -> Stone7Index is LeftUp; Stone7Index is -1),
    (LeftDown is LastPlayedIndex+3, member(LeftDown,Player2Stones) -> Stone8Index is LeftDown; Stone8Index is -1),
  
    Jumpdirection1 is (Stone1Index-LastPlayedIndex)*(-1),
    Jumpdirection2 is (Stone2Index-LastPlayedIndex)*(-1), 
    Jumpdirection3 is (Stone3Index-LastPlayedIndex)*(-1),
    Jumpdirection4 is (Stone4Index-LastPlayedIndex)*(-1), 
    Jumpdirection5 is (Stone5Index-LastPlayedIndex)*(-1), 
    Jumpdirection6 is (Stone6Index-LastPlayedIndex)*(-1), 
    Jumpdirection7 is (Stone7Index-LastPlayedIndex)*(-1), 

    verify_can_jump(Stone1Index, 2, Jumpdirection1, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone2Index, 2, Jumpdirection2, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone3Index, 2, Jumpdirection3, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone4Index, 2, Jumpdirection4, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone5Index, 2, Jumpdirection5, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone6Index, 2, Jumpdirection6, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone7Index, 2, Jumpdirection7, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone8Index, 2, Jumpdirection8, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).



bot_jump_over_stone(Elements, 1, LastPlayedIndex, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
/* Saber as pedras que estão próximas daquela que está perto da nossa */ 
   
    (Up is LastPlayedIndex-4, member(Up,Player1Stones) -> Stone1Index is Up; Stone1Index is -1),
    (Down is LastPlayedIndex+4, member(Down,Player1Stones) -> Stone2Index is Down; Stone2Index is -1),
    (Right is LastPlayedIndex+1, member(Right,Player1Stones) -> Stone3Index is Right; Stone3Index is -1),
    (Left is LastPlayedIndex-1, member(Left,Player1Stones) -> Stone4Index is Left; Stone4Index is -1),
    (RightUp is LastPlayedIndex-3, member(RightUp,Player1Stones) -> Stone5Index is RightUp; Stone5Index is -1),
    (RightDown is LastPlayedIndex+5, member(RightDown,Player1Stones) -> Stone6Index is RightDown; Stone6Index is -1),
    (LeftUp is LastPlayedIndex-5, member(LeftUp,Player1Stones) -> Stone7Index is LeftUp; Stone7Index is -1),
    (LeftDown is LastPlayedIndex+3, member(LeftDown,Player1Stones) -> Stone8Index is LeftDown; Stone8Index is -1),
  
    Jumpdirection1 is (Stone1Index-LastPlayedIndex)*(-1),
    Jumpdirection2 is (Stone2Index-LastPlayedIndex)*(-1), 
    Jumpdirection3 is (Stone3Index-LastPlayedIndex)*(-1),
    Jumpdirection4 is (Stone4Index-LastPlayedIndex)*(-1), 
    Jumpdirection5 is (Stone5Index-LastPlayedIndex)*(-1), 
    Jumpdirection6 is (Stone6Index-LastPlayedIndex)*(-1), 
    Jumpdirection7 is (Stone7Index-LastPlayedIndex)*(-1), 

    verify_can_jump(Stone1Index, 1, Jumpdirection1, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType),
    verify_can_jump(Stone2Index, 1, Jumpdirection2, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone3Index, 1, Jumpdirection3, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone4Index, 1, Jumpdirection4, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone5Index, 1, Jumpdirection5, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone6Index, 1, Jumpdirection6, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), 
    verify_can_jump(Stone7Index, 1, Jumpdirection7, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType),
    verify_can_jump(Stone8Index, 1, Jumpdirection8, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).


verify_can_jump(StoneIndex, CurrPlayer, Jumpdirection, Elements, Player1Stones, Player2Stones, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    if(StoneIndex > -1 , bot_make_jump(Elements, CurrPlayer, Player1Stones, Player2Stones, Jumpdirection, StoneIndex, LastPlayedIndex, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType), true).

bot_make_jump(Elements, CurrPlayer, Player1Stones, Player2Stones, Jumpdirection, StartPoint, StoneToBeDeleted, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    Attempt1 is StartPoint+Jumpdirection+Jumpdirection,

    if(is_next_position_valid(Attempt1), true, true), 

    /* Verificar se a Posição a seguir está ocupada pelo inimigo ou tem uma pedra do player atual */
    if(occupied_rec(Elements, Attempt1), write('Position occupied! Attempting next position...'), bot_finalize_make_jump(Elements, CurrPlayer, StartPoint, Player1Stones, Player2Stones, Attempt1, StoneToBeDeleted, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType)).

bot_finalize_make_jump(Elements, 1, StartPoint, Player1Stones, Player2Stones, NewStonePosition, StoneToBeDeleted, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-
    /* Atualizar a Posição da Peça */ 
    replace(Elements, StartPoint, 0, NewElements),
    replace(NewElements, NewStonePosition, 1, UpdatedElements),

    /* Retirar a pedra comida do tabuleiro */
    replace(UpdatedElements, StoneToBeDeleted, 0, FinalElements),

    /* Atualizar o Vetor de Pedras de Ambos os Players */
    append(Player1Stones, [NewStonePosition], NewPlayer1Stones),
    delete(StartPoint, NewPlayer1Stones, FinalPlayer1Stones),
    delete(StoneToBeDeleted, Player2Stones, NewPlayer2Stones),
    /* TODO Incrementar a contagem de Pedras comidas do Player*/
    NewCapturedStones1 is CapturedStones1 + 1,

    /* Finalizar o movement -> Update do estado do tabuleiro */
    finish_player_turn(FinalElements, 1, NewStonePosition, FinalPlayer1Stones, NewPlayer2Stones, NewCapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).


bot_finalize_make_jump(Elements, 2, StartPoint, Player1Stones, Player2Stones, NewStonePosition, StoneToBeDeleted, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType):-

    /* Atualizar a Posição da Peça */ 
    replace(Elements, StartPoint, 0, NewElements),
    replace(NewElements, NewStonePosition, 2, UpdatedElements),

    /* Retirar a pedra comida do tabuleiro */
    replace(UpdatedElements, StoneToBeDeleted, 0, FinalElements),

    /* Atualizar o Vetor de Pedras de Ambos os Players */
    append(Player2Stones, [NewStonePosition], NewPlayer2Stones),
    delete(StartPoint, NewPlayer2Stones, FinalPlayer2Stones),
    delete(StoneToBeDeleted, Player1Stones, NewPlayer1Stones),
    
    /* TODO Incrementar a contagem de Pedras comidas do Player*/
    NewCapturedStones2 is CapturedStones2 + 1,

    /* Finalizar o movement -> Update do estado do tabuleiro */
    finish_player_turn(FinalElements, 2, NewStonePosition, NewPlayer1Stones, FinalPlayer2Stones, CapturedStones1, NewCapturedStones2, Stone1Num, Stone2Num, GameType).

% ------------------- Start Game -----------------------

game:- board([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],Board),
       get_elements(Board,Elements),
       draw_board(Elements),
       player_turn(Elements, 1, 0, [], [], 0, 0, 8, 8, 1).

play(Player, Bot) :- 
    board([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],Board),
    get_elements(Board,Elements),
    draw_board(Elements),
    player_turn(Elements, 1, 0, [], [], 0, 0, 8, 8, 2).

play(Bot, Bot) :- 
    board([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],Board),
    get_elements(Board,Elements),
    draw_board(Elements),
    bot_turn(Elements, 1, 0, [], [], 0, 0, 8, 8).

