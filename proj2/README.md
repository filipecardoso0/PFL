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
