place_piece_AI(Elements, CurrPlayer, PlayerStones, AIStones, PlayerDropCntr, AIDropCntr, PlayerEaten, AIEaten):-
    
    PlayerDropCntr == 0 -> place_piece_AI_center(Elementes, CurrPlayer, PlayerStones, AIStones, PlayerDropCntr, AIDropCntr, PlayerEaten, AIEaten),

place_piece_AI_center(Elements, CurrPlayer, PlayerStones, AIStones, PlayerDropCntr, AIDropCntr, PlayerEaten, AIEaten):-
    between(5, 10, RandomPos), 

    /* Place the piece onto the board */
    replace(Elements, )
