
# takuzu.py: Template para implementação do projeto de Inteligência Artificial 2021/2022.
# Devem alterar as classes e funções neste ficheiro de acordo com as instruções do enunciado.
# Além das funções e classes já definidas, podem acrescentar outras que considerem pertinentes.

# Grupo 37:
# 99075 Guilherme Batalheiro
# 99081 Henrique Anjos

import copy
import sys
import numpy as np
from search import (
    Problem,
    Node,
    astar_search,
    breadth_first_tree_search,
    compare_graph_searchers,
    depth_first_tree_search,
    greedy_search,
    recursive_best_first_search,
    compare_searchers,
)


class TakuzuState:
    state_id = 0

    def __init__(self, board):
        self.board = board
        self.id = TakuzuState.state_id
        TakuzuState.state_id += 1

    def __lt__(self, other):
        return self.id < other.id


class Board:
    """Representação interna de um tabuleiro de Takuzu."""

    def __init__(self, size: int, board_tiles=[]):
        """Cria uma instancia da class Board."""
        self.size = size
        if(len(board_tiles) == 0):
            struct = (size, size)

            self.board_tiles = np.full(struct, 2)
        else:
            self.board_tiles = board_tiles

    def get_number(self, row: int, col: int) -> int:
        """Devolve o valor na respetiva posição do tabuleiro."""
        return self.board_tiles[row][col]

    def adjacent_vertical_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os valores imediatamente abaixo e acima,
        respectivamente."""
        return (self.board_tiles[row + 1][col] if row + 1 < self.size else None,
                self.board_tiles[row - 1][col] if row - 1 >= 0 else None)

    def adjacent_horizontal_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os valores imediatamente à esquerda e à direita,
        respectivamente."""
        return (self.board_tiles[row][col - 1] if col - 1 >= 0 else None,
                self.board_tiles[row][col + 1] if col + 1 < self.size else None)

    def two_above_adjacent_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os dois valores imediatamente acima."""
        return (self.board_tiles[row - 1][col] if row - 1 >= 0 else None,
                self.board_tiles[row - 2][col] if row - 2 >= 0 else None)

    def two_bellow_adjacent_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os dois valores imediatamente abaixo."""
        return (self.board_tiles[row + 1][col] if row + 1 < self.size else None,
                self.board_tiles[row + 2][col] if row + 2 < self.size else None)

    def two_left_adjacent_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os dois valores imediatamente à esquerda."""
        return (self.board_tiles[row][col - 1] if col - 1 >= 0 else None,
                self.board_tiles[row][col - 2] if col - 2 >= 0 else None)

    def two_rigth_adjacent_numbers(self, row: int, col: int) -> (int, int):
        """Devolve os dois valores imediatamente à direita."""
        return (self.board_tiles[row][col + 1] if col + 1 < self.size else None,
                self.board_tiles[row][col + 2] if col + 2 < self.size else None)

    def do_action(self,  row: int, col: int, val: int) -> None:
        self.board_tiles[row][col] = val

    @staticmethod
    def parse_instance_from_stdin():
        """Lê o test do standard input (stdin) que é passado como argumento
        e retorna uma instância da classe Board.

        Por exemplo:
            $ python3 takuzu.py < input_T01

            > from sys import stdin
            > stdin.readline()
        """
        size = int(sys.stdin.readline())
        board = Board(size)

        for i in range(size):
            line = sys.stdin.readline().replace("\t", "")
            for j in range(size):
                board.do_action(i, j, int(line[j]))

        return board

    def __str__(self):
        size = self.size
        res = '\n'.join(
            ['\t'.join(
                [str(self.get_number(i, j)) for j in range(size)]
            ) for i in range(size)]
        )
        return str(size)


class Takuzu(Problem):
    def __init__(self, board: Board):
        """O construtor especifica o estado inicial."""
        self.board = board
        self.initial = TakuzuState(board)

    def actions(self, state: TakuzuState):
        """Retorna uma lista de ações que podem ser executadas a
        partir do estado passado como argumento."""
        board = state.board
        board_tiles = board.board_tiles
        board_sum_line_zero = np.count_nonzero(board_tiles == 0, axis=1)
        board_sum_line_one = np.count_nonzero(board_tiles == 1, axis=1)
        board_sum_col_zero = np.count_nonzero(board_tiles.T == 0, axis=1)
        board_sum_col_one = np.count_nonzero(board_tiles.T == 1, axis=1)
        board_size = board.size

        first = True

        for line in range(board_size):
            for col in range(board_size):
                if (board.get_number(line, col) == 2):
                    if(first):
                        first = False
                        first_line = line
                        first_col = col

                    # Se a linha tiver mais de metade de um numero preenche com
                    # o outro.
                    if(board_size % 2 == 0):
                        if(board_sum_line_zero[line] >= board_size / 2 or
                                board_sum_col_zero[col] >= board_size / 2):
                            return[(line, col, 1)]
                        if(board_sum_line_one[line] >= board_size / 2 or
                                board_sum_col_one[col] >= board_size / 2):
                            return[(line, col, 0)]
                    else:
                        if(board_sum_line_zero[line] > board_size / 2 or
                                board_sum_col_zero[col] > board_size / 2):
                            return[(line, col, 1)]
                        if(board_sum_line_one[line] > board_size / 2 or
                                board_sum_col_one[col] > board_size / 2):
                            return[(line, col, 0)]

                    adjacent_vertical = board.adjacent_vertical_numbers(line, col)
                    adjacent_horizontal = board.adjacent_horizontal_numbers(line, col)
                    two_letf_adjacent = board.two_left_adjacent_numbers(line, col)
                    two_rigth_adjacent = board.two_rigth_adjacent_numbers(line, col)
                    two_above_adjacent = board.two_above_adjacent_numbers(line, col)
                    two_bellow_adjacent = board.two_bellow_adjacent_numbers(line, col)

                    # Check if the adjacet vertical numbers are equal
                    if (adjacent_vertical[0] == adjacent_vertical[1] and
                            adjacent_vertical[0] in [0, 1]):
                        return [(line, col, (adjacent_vertical[0]-1)**2)]

                    # Check if the adjacent horizontal numbers are equal
                    if (adjacent_horizontal[0] == adjacent_horizontal[1] and
                            adjacent_horizontal[0] in [0, 1]):
                        return [(line, col, (adjacent_horizontal[0]-1)**2)]

                    # Check if the above two adjacent numbers are equal
                    if (two_above_adjacent[0] == two_above_adjacent[1]
                            and two_above_adjacent[0] in [0, 1]):
                        return [(line, col, (two_above_adjacent[0] - 1)**2)]

                    # Check if the bellow two adjacent numbers are equal
                    if (two_bellow_adjacent[0] == two_bellow_adjacent[1] and
                            two_bellow_adjacent[0] in [0, 1]):
                        return [(line, col, (two_bellow_adjacent[0] - 1)**2)]

                    # Check if the left two adjacent numbers are equal
                    if (two_letf_adjacent[0] == two_letf_adjacent[1] and
                            two_letf_adjacent[0] in [0, 1]):
                        return [(line, col, (two_letf_adjacent[0] - 1)**2)]

                    # Check if the rigth two adjacent numbers are equal
                    if (two_rigth_adjacent[0] == two_rigth_adjacent[1] and
                            two_rigth_adjacent[0] in [0, 1]):
                        return [(line, col, (two_rigth_adjacent[0] - 1)**2)]

        if(first == False):
            return [(first_line, first_col, 0), (first_line, first_col, 1)]
        return []

    def result(self, state: TakuzuState, action: (int, int, int)) -> TakuzuState:
        """Retorna o estado resultante de executar a 'action' sobre
        'state' passado como argumento. A ação a executar deve ser uma
        das presentes na lista obtida pela execução de
        self.actions(state)."""

        new_state = copy.deepcopy(state)
        new_state.board.do_action(action[0], action[1], action[2])

        return new_state

    def goal_test(self, state: TakuzuState):
        """Retorna True se e só se o estado passado como argumento é
        um estado objetivo. Deve verificar se todas as posições do tabuleiro
        estão preenchidas com uma sequência de números adjacentes."""

        board = state.board
        board_tiles = board.board_tiles

        # Verifica que todas as posicoes no tabuleiro estao preenchidas
        if (np.count_nonzero(board_tiles == 2) != 0):
            return False

        # Avalia se todas as linhas dão diferentes
        if (len(set(map(tuple, board_tiles))) != len(board_tiles)):
            return False

        # Avalia se todas as colunas são diferentes dão diferentes
        if (len(set(map(tuple, board_tiles.T))) != len(board_tiles)):
            return False

        # Avalia se não não há mais do que dois números iguais adjacentes
        # (horizontal ou verticalmente) um ao outro.
        for line in board_tiles:
            n = None
            c = 0
            for cell in line:
                if(cell != n):
                    n = cell
                    c = 0
                if(c == 2):
                    return False
                else:
                    c += 1

        for line in board_tiles.T:
            n = None
            c = 0
            for cell in line:
                if(cell != n):
                    n = cell
                    c = 0
                if(c == 2):
                    return False
                else:
                    c += 1

        # Avalia se há um número igual de 1s e 0s em cada coluna
        # (ou mais um para grelhas de dimensão ímpar)
        board_sum_col = np.sum(board_tiles.T, axis=1)
        for col_sum in board_sum_col:
            if (not(col_sum == board.size / 2
                if board.size % 2 == 0
                else (col_sum == int(board.size / 2)
                      or col_sum == int(board.size / 2) + 1))):
                return False

        # Avalia se há um número igual de 1s e 0s em cada linha
        # (ou mais um para grelhas de dimensão ímpar)
        board_sum_line = np.sum(board_tiles, axis=1)
        for line_sum in board_sum_line:
            if (not(line_sum == board.size / 2
                if board.size % 2 == 0
                else (line_sum == int(board.size / 2)
                      or line_sum == int(board.size / 2) + 1))):
                return False

        return True

    def h(self, node: Node):
        """Função heuristica utilizada para a procura A*."""

        h = 9999

        board = node.state.board
        board_tiles = board.board_tiles
        board_sum_line_zero = np.count_nonzero(board_tiles == 0, axis=1)
        board_sum_line_one = np.count_nonzero(board_tiles == 1, axis=1)
        board_sum_col_zero = np.count_nonzero(board_tiles.T == 0, axis=1)
        board_sum_col_one = np.count_nonzero(board_tiles.T == 1, axis=1)
        board_size = board.size


        for line in range(board_size):
            for col in range(board_size):
                if (board.get_number(line, col) == 2):
                    n = 2
                    first = True

                    # Se a linha tiver mais de metade de um numero preenche com
                    # o outro.
                    if(board_size % 2 == 0):
                        if(board_sum_line_zero[line] >= board_size / 2 or
                                board_sum_col_zero[col] >= board_size / 2):
                            if(first):
                                h-=1
                                n = 1
                                first = False
                            elif(n != 1):
                                return 9999

                        if(board_sum_line_one[line] >= board_size / 2 or
                                board_sum_col_one[col] >= board_size / 2):
                            if(first):
                                h-=1
                                n = 0
                                first = False
                            elif(n != 0):
                                return 9999
                    else:
                        if(board_sum_line_zero[line] > board_size / 2 or
                                board_sum_col_zero[col] > board_size / 2):
                            if(first):
                                h-=1
                                n = 1
                                first = False
                            elif(n != 1):
                                return 9999

                        if(board_sum_line_one[line] > board_size / 2 or
                                board_sum_col_one[col] > board_size / 2):
                            if(first):
                                h-=1
                                n = 0 
                                first = False
                            elif(n != 0):
                                return 9999

                    adjacent_vertical = board.adjacent_vertical_numbers(line, col)
                    adjacent_horizontal = board.adjacent_horizontal_numbers(line, col)
                    two_letf_adjacent = board.two_left_adjacent_numbers(line, col)
                    two_rigth_adjacent = board.two_rigth_adjacent_numbers(line, col)
                    two_above_adjacent = board.two_above_adjacent_numbers(line, col)
                    two_bellow_adjacent = board.two_bellow_adjacent_numbers(line, col)

                    # Check if the adjacet vertical numbers are equal
                    if (adjacent_vertical[0] == adjacent_vertical[1] and
                            adjacent_vertical[0] in [0, 1]):
                        if(first):
                            h-=1
                            n = (adjacent_vertical[0]-1)**2
                            first = False
                        elif(n != (adjacent_vertical[0]-1)**2):
                            return 99999

                    # Check if the adjacent horizontal numbers are equal
                    if (adjacent_horizontal[0] == adjacent_horizontal[1] and
                            adjacent_horizontal[0] in [0, 1]):
                        if(first):
                            h-=1
                            n = (adjacent_horizontal[0]-1)**2
                            first = False
                        elif(n != (adjacent_horizontal[0]-1)**2):
                            return 99999

                    # Check if the above two adjacent numbers are equal
                    if (two_above_adjacent[0] == two_above_adjacent[1]
                            and two_above_adjacent[0] in [0, 1]):
                        if(first):
                            h-=1
                            n = (two_above_adjacent[0]-1)**2
                            first = False
                        elif(n != (two_above_adjacent[0]-1)**2):
                            return 99999

                    # Check if the bellow two adjacent numbers are equal
                    if (two_bellow_adjacent[0] == two_bellow_adjacent[1] and
                            two_bellow_adjacent[0] in [0, 1]):
                        if(first):
                            h-=1
                            n = (two_bellow_adjacent[0]-1)**2
                            first = False
                        elif(n != (two_bellow_adjacent[0]-1)**2):
                            return 99999

                    # Check if the left two adjacent numbers are equal
                    if (two_letf_adjacent[0] == two_letf_adjacent[1] and
                            two_letf_adjacent[0] in [0, 1]):
                        if(first):
                            h-=1
                            n = (two_letf_adjacent[0]-1)**2
                            first = False
                        elif(n != (two_letf_adjacent[0]-1)**2):
                            return 99999

                    # Check if the rigth two adjacent numbers are equal
                    if (two_rigth_adjacent[0] == two_rigth_adjacent[1] and
                            two_rigth_adjacent[0] in [0, 1]):
                        if(first):
                            h-=1
                            n = (two_rigth_adjacent[0]-1)**2
                            first = False
                        elif(n != (two_rigth_adjacent[0]-1)**2):
                            return 99999
        return h


if __name__ == "__main__":
    # Ler tabuleiro do ficheiro 'i1.txt'(Figura 1):
    # $ python3 takuzu < i1.txt
    board = Board.parse_instance_from_stdin()
    # Criar uma instância de Takuzu:
    problem = Takuzu(board)
    # Obter o nó solução usando a procura em profundidade:
    #tirar 
    """
    goal_node = greedy_search(problem)
    print("Is goal?", problem.goal_test(goal_node.state))
    print("Solution:\n", goal_node.state.board, sep="")
    """
    compare_searchers(problems=[problem],
                      header=['Searcher', 'Results'],
                      searchers=[astar_search,
                                breadth_first_tree_search,
                                depth_first_tree_search,
                                greedy_search])
