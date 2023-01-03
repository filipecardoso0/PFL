# TP2 -  Turma 12  Grupo Moxie_4

| Estudante                     | Número    | Contribuição |
| ----------------------------- | --------- | ------------ |
| Filipe de Azevedo Cardoso     | 202006409 |      50%     |
| Pedro Joaquim Alves Oliveira  | 202004324 |      50%     |

## Instalação e execução


## Descrição do jogo

O [Moxie](https://www.di.fc.ul.pt/~jpn/gv/moxie.htm) e um jogo de tabuleiro 4X4, inicialmente vazio, para 2 pessoas e com cada jogador a ter na sua posse oito peças fora do tabuleiro.
A cada jogada cada jogador deve fazer uma das seguintes ações: 
 * Colocar uma peça num espaço vazio.
 * Mover uma peça, já colocada, num espaço adjacente na ortogonal ou diagonal.
 * Saltar por cima de uma peça inimiga, ficando na poseção imediatamente adjacente a esta, e capturando-a.
     * Os saltos são obrigatórios caso a possibilidade e têm prioridade sobre uma colocação de peça nova ou o movimento.
     * Vários saltos consecutivos, se possível, são também obrigatórios.
 
Um jogador vence caso possua, no ortogonal ou diagonal, 3 peças seguidas, ou tenha capturado 6 peças do inimigo.
(*Harold C. Manley, 1956*)

## Lógica do jogo

### Representação interna do estado do jogo 

Atraves da chamada ao predicado play/0, temos tudo o que precisamos para, dar display ao nosso menu, onde sera pedido ao Utilizador que escolha 1 de 3 opcoes  disponibilizadas, sendo que a 1º opcao, leva o para o nosso Main_Menu onde ira escolher qual o modo de jogo a jogar, a 2ª opçao, indica-lhe as regras do jogo e a 3ª opçao termina com o jogo. Para alem disso utilizamos um vetor Elements com tamanho 16 para guardar o estado do tabuleiro. 
Utilizamos as variaveis CurrPlayer, Player1Stones, Player2Stones, CapturesStones1, CapturedStones2, Stone1Num, Stone2Num, GameType para monitorizar o estado atual do jogo.

### Visualizaçao do Estado do Jogo

Para a constante visualizaçao do jogo, é utilizado o predicado draw_board/1 a cada mudança de turno de jogador e a cada salto que resulte em comer uma peça inimiga,a partir dos Elements atualizados.

### Lista de Jogadas Validas

Para a visualizaçao da lista de Jogadas Validas, definimos o predicado search_for_adjacent_pieces/10, que a partir do Índice de uma peça, colocamos na lista Adjacent, todas as peças adjacentes que nao estejam ocupadas.

### Final do Jogo

Verificamos o final do jogo atraves do predicado verify_win_state/3 que verifica a partir dos Elements passados como argumento, se o CurrPlayer, tambem ele passado como argumento, tem alguma sequência de 3 peças seguidas, quer seja na diagonal, vertical ou horizontal. Com o predicado verify_win_state/3, verificamos tambem se o CurrPlayer comeu mais de 6 peças inimigas, vencendo assim o jogo.

### Jogada do Computador

Como jogadas do computador implementamos os predicados bot_jump_over_stone/10 e bot_turn_DropOrMove/9 que permitem respetivamente, saltar, capturando assim peças inimigas, e selecionar aleatoriamente, qual a jogada  entre mover uma peça ou colocar outra no tabuleiro.

## Conclusões

Graças a este trabalho, foi possivel, laminar e obter o melhor conhecimento em prolog, nomeadamente em relaçao a programaçao logica e, apesar de ser bastante exigente a nivel logico e cognitivo acaba por se gratificante a nivel de eficacia e rapidez, pois permite escrever codigo de forma bastante sucinta.
Porém a necessidade de implementar uma Intelêngia Artificial, que por sua vez, não tinha sido lecionada ainda no decorrer do curso, tornou esta tarefa bastante desafiante, uma vez que estavamos a trabalhar com uma linguagem nao pertencente ao dominio imperativo, dificultou a tarefa da criaçao da intelengia artificial de forma exponencial.


