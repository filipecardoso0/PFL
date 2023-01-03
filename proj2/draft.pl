    /* DROP STONE */
    RandomVal == 2 -> search_for0_rec(Elements, [], 0, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType);
    /* MOVE STONE */
    RandomVal == 1 -> search_forPiece_rec(Elements, [], 0, Elements, CurrPlayer, Player1Stones, Player2Stones, CapturedStones1, CapturedStones2, Stone1Num, Stone2Num, GameType).