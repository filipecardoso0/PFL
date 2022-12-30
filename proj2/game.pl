% Main menu for choosing a game mode
main_menu:-
    write('Please choose a game mode:'), nl,
    write('1. Computer vs Computer'), nl,
    write('2. Human vs Human'), nl,
    write('3. Human vs Computer mode: Easy'), nl,
    write('4. Human vs Computer mode: Hard'), nl,
    write('Enter your choice (1-4): '),
    read(Choice),
    (
        Choice = 1 -> bot_vs_bot;
        Choice = 2 -> human_vs_human;
        Choice = 3 -> human_vs_easy_bot;
        Choice = 4 -> human_vs_hard_bot
    ).

% Game mode: Computer vs Computer
bot_vs_bot:-
    write('Starting Computer vs Computer game...').

% Game mode: Human vs Human
human_vs_human:-
    write('Starting Human vs Human game...').

% Game mode: Human vs Computer mode : easy
human_vs_easy_bot:-
    write('Starting Human vs Easy Computer game...').

% Game mode: Human vs Computer mode : hard
human_vs_easy_bot:-
    write('Starting Human vs Hard Computer game...').