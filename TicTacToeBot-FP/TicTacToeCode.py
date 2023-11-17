# Henrique Anjos 199081

# Projeto Jogo do Galo

# Funcao auxiliar

def tab_para_lista(tab):
    """
    Transforma um tabuleiro numa lista com os mesmos elementos, pela mesma ordem

    :param tab: tabuleiro
    :return: lista
    """

    return [i for linha in tab for i in linha]


# Inicio

def eh_tabuleiro(tab):
    """
    Recebe um argumento de qualquer tipo e devolve True se o seu argumento
    corresponde a um tabuleiro e False caso contrario

    Nota: Um tabuleiro consiste de um tuplo de 3 tuplos, contesndo cada 3 valores, sendo estes (-1, 0 ou 1)

    :param tab: tabuleiro
    :return: booleano
    """
    
    a = 0
    if type(tab) == tuple:
        for linha in tab:
            if type(linha) == tuple:
                for i in linha:
                    if i in (-1, 0, 1) and type(i) == int:
                        a += 1

    return a == 9


def eh_posicao(n):
    """
    Recebe um argumento de qualquer tipo e devolve True se o seu argumento
    corresponde a uma posicao e False caso contrario

    Nota: Uma posicao valida e um numero inteiro de 1 a 9

    :param n: inteiro
    :return: booleano
    """

    return type(n) == int and 0 < n < 10


def obter_coluna(tab, n):
    """
    Recebe um tabuleiro e um inteiro com valor de 1 a 3 que representa o numero
    da coluna, e devolve um vector com os valores dessa coluna

    :param tab: tabuleiro
    :param n: inteiro
    :return: tuplo

    Erros: Se algum dos argumentos dados forem invalidos, a funcao gera
    um erro com a mensagem "obter_coluna: algum dos argumentos e invalido"
    """

    if not eh_tabuleiro(tab) or type(n) != int or n not in [1, 2, 3]:
        raise ValueError("obter_coluna: algum dos argumentos e invalido")
    coluna = ()
    for linha in tab:
        coluna += (linha[n-1],)

    return coluna


def obter_linha(tab, n):
    """
    Recebe um tabuleiro e um inteiro com valor de 1 a 3 que representa o numero
    da linha, e devolve um vector com os valores dessa linha

    :param tab: tabuleiro
    :param n: inteiro
    :return: tuplo

    Erros: Se algum dos argumentos dados forem invalidos, a funcao gera um
    erro com a mensagem "obter_linha: algum dos argumentos e invalido"
    """

    if not eh_tabuleiro(tab) or type(n) != int or n not in [1, 2, 3]:
        raise ValueError("obter_linha: algum dos argumentos e invalido")

    return tab[n-1]


def obter_diagonal(tab, n):
    """
    Esta funcao recebe um tabuleiro e um inteiro que representa a direccao da diagonal, 1
    para descendente da esquerda para a direita e 2 para ascendente da esquerda para a
    direita, e devolve um vector com os valores dessa diagonal

    :param tab: tabuleiro
    :param n: inteiro
    :return: tuplo

    Erros: Se algum dos argumentos dados forem invalidos, a funcao gera um erro
    com a mensagem 'obter_diagonal: algum dos argumentos e invalido'
    """

    if not eh_tabuleiro(tab) or type(n) != int or n not in [1, 2]:
        raise ValueError("obter_diagonal: algum dos argumentos e invalido")
    if n == 1:
        diagonal = (tab[0][0], tab[1][1], tab[2][2])
    else:
        diagonal = (tab[2][0], tab[1][1], tab[0][2])

    return diagonal


def tabuleiro_str(tab):
    """
    Recebe um tabuleiro e devolve a cadeia de caracteres que o representa
    (a representacao externa ou representacao "para os nossos olhos")

    :param tab: tabuleiro
    :return: string

    Erros: Se o argumento dado for invalido, a funcao gera um erro
    com a mensagem 'tabuleiro_str: o argumento e invalido'
    """

    if not eh_tabuleiro(tab):
        raise ValueError("tabuleiro_str: o argumento e invalido")

    lis = tab_para_lista(tab)
    for i in range(len(lis)):
        if lis[i] == 1:
            lis[i] = "X"
        elif lis[i] == -1:
            lis[i] = "O"
        else:
            lis[i] = " "

    return " " + lis[0] + " | " + lis[1] + " | " + lis[2] + " \n-----------\n " + lis[3] + " | "\
           + lis[4] + " | " + lis[5] + " \n-----------\n " + lis[6] + " | " + lis[7] + " | " + lis[8] + " "


def eh_posicao_livre(tab, pos):
    """
    Recebe um tabuleiro e uma posicao, e devolve True se a posicao corresponde
    a uma posicao livre do tabuleiro e False caso contrario

    :param tab: tabuleiro
    :param pos: inteiro
    :return: booleano

    Erros: Se algum dos argumentos dado for invalido, a funcao gera um erro
    com a mensagem 'eh_posicao_livre: algum dos argumentos e invalido'
    """

    if not eh_tabuleiro(tab) or not eh_posicao(pos):
        raise ValueError("eh_posicao_livre: algum dos argumentos e invalido")

    return tab_para_lista(tab)[pos-1] == 0


def obter_posicoes_livres(tab):
    """
    Recebe um tabuleiro, e devolve o vector ordenado com todas as posicoes
    livres do tabuleiro

    :param tab: tabuleiro
    :return: tuplo

    Erros: Se o argumento dado for invalido, a funcao gera um erro com
    a mensagem 'obter_posicoes_livres: o argumento e invalido'
    """

    if not eh_tabuleiro(tab):
        raise ValueError("obter_posicoes_livres: o argumento e invalido")
    tuplo = ()
    for i in range(1, 10):
        if eh_posicao_livre(tab, i):
            tuplo += (i,)

    return tuplo


def jogador_ganhador(tab):
    """
    Recebe um tabuleiro, e devolve um valor inteiro a indicar o jogador que
    ganhou a partida no tabuleiro passado por argumento, sendo o valor igual a 1 se ganhou
    o jogador que joga com 'X', -1 se ganhou o jogador que joga com 'O', ou 0 se nao ganhou
    nenhum jogador

    :param tab: tabuleiro
    :return: inteiro

    Erros: Se o argumento dado for invalido, a funcao gera um erro com a
    mensagem 'jogador_ganhador: o argumento e invalido'
    """

    if not eh_tabuleiro(tab):
        raise ValueError("jogador_ganhador: o argumento e invalido")

    for k in (-1, 1):
        for i in range(1, 4):
            if obter_coluna(tab, i) == (k, k, k) or obter_linha(tab, i) == (k, k, k):
                return k
        for i in range(1, 3):
            if obter_diagonal(tab, i) == (k, k, k):
                return k
    return 0


def marcar_posicao(tab, n, pos):
    """
    Recebe um tabuleiro, um inteiro identificando um jogador (1 para o jogador
    'X' ou -1 para o jogador 'O') e uma posicao livre, e devolve um novo tabuleiro modificado
    com uma nova marca do jogador nessa posicao

    :param tab: tabuleiro
    :param n: inteiro
    :param pos: inteiro
    :return: tabuleiro

    Erros: Se algum dos argumentos dados forem invalidos, a funcao gera um erro
    com a mensagem 'marcar_posicao: algum dos argumentos e invalido'.
    """

    if not eh_tabuleiro(tab) or n not in [1, -1] or pos not in obter_posicoes_livres(tab) or type(n) != int:
        raise ValueError("marcar_posicao: algum dos argumentos e invalido")
    tab1 = tab_para_lista(tab)
    tab1[pos-1] = n
    tab2 = ((tab1[0], tab1[1], tab1[2]), (tab1[3], tab1[4], tab1[5]), (tab1[6], tab1[7], tab1[8]))

    return tab2


def escolher_posicao_manual(tab):
    """
    Realiza a leitura de uma posicao introduzida manualmente por um jogador
    e devolve esta posicao escolhida

    :param tab: tabuleiro
    :return: inteiro

    Erros: Se o valor introduzido nao corresponder a uma posicao livre do tabuleiro, a
    funcao gera um erro com a mensagem 'escolher_posicao_manual: a posicao introduzida e invalida'
    """

    if not eh_tabuleiro(tab):
        raise ValueError("escolher_posicao_manual: o argumento e invalido")
    pos = int(input("Turno do jogador. Escolha uma posicao livre: "))
    if pos not in obter_posicoes_livres(tab):
        raise ValueError("escolher_posicao_manual: a posicao introduzida e invalida")

    return pos


# Regras


def regra1(tab, n):
    """
    Recebe um tabuleiro e um inteiro  identificando um jogador (1 para o jogador
    'X' ou -1 para o jogador 'O') e devolve a posicao livre que respeita o criterio 1, caso o
    criterio nao se verifique devolve False

    (se o jogador tiver duas das suas pecas em linha e uma posicao livre
    entao deve marcar na posicao livre (ganhando o jogo)

    :param tab: tabuleiro
    :param n: inteiro (1 ou -1)
    :return: inteiro ou False
    """

    for i in obter_posicoes_livres(tab):
        if jogador_ganhador(marcar_posicao(tab, n, i)):
            return i
    else:
        return False


def regra2(tab, n):
    """
    Recebe um tabuleiro e um inteiro  identificando um jogador (1 para o jogador
    'X' ou -1 para o jogador 'O') e devolve a posicao livre que respeita o criterio 2, caso o
    criterio nao se verifique devolve False

    (se o adversario tiver duas das suas pecas em linha e uma posicao livre
    entao deve marcar na posicao livre (para bloquear o adversario))

    :param tab: tabuleiro
    :param n: inteiro (1 ou -1)
    :return: inteiro ou False
    """

    for i in obter_posicoes_livres(tab):
        if jogador_ganhador(marcar_posicao(tab, -n, i)):
            return i
    else:
        return False


def regra3(tab, n):
    """
    Recebe um tabuleiro e um inteiro  identificando um jogador (1 para o jogador
    'X' ou -1 para o jogador 'O') e devolve a posicao livre que respeita o criterio 3, caso o
    criterio nao se verifique devolve False

    (se o jogador tiver duas linhas/colunas/diagonais que se intersectam, onde cada
    uma contem uma das suas pecas, e se a posicao de interseccao estiver livre
    entao deve marcar na posicao de interseccao (criando duas formas de vencer na
    jogada seguinte))

    :param tab: tabuleiro
    :param n: inteiro (1 ou -1)
    :return: inteiro ou False
    """

    for i in obter_posicoes_livres(tab):
        if regra1(marcar_posicao(tab, n, i), n) is not False:                                                   # jogando na posicao i verifica se faz um 2 em linha
            new_tab = marcar_posicao(marcar_posicao(tab, n, i), -n, regra1(marcar_posicao(tab, n, i), n))       # o jogador adversario joga na posicao que impede o 3 em linha
            if regra1(new_tab, n) is not False:                                                                 # verifica se contnua a haver um 2 em linha em que possa ganhar
                return i                                                                                        # concluindo que jogar na posicao i faz dois 2 em linha
    else:
        return False


def regra4(tab, n):
    """
    Recebe um tabuleiro e um inteiro  identificando um jogador (1 para o jogador
    'X' ou -1 para o jogador 'O') e devolve a posicao livre que respeita o criterio 4, caso o
    criterio nao se verifique devolve False

    (se o adversario tiver apenas uma bifurcacao entao o jogador deve bloquear a
    bifurcacao (escolher a posicao livre da interseccao) senao o jogador deve criar
    um dois em linha para forcar o oponente a defender, desde que a defesa nao resulte
    na criacao de uma bifurcacao para o oponente)

    :param tab: tabuleiro
    :param n: inteiro (1 ou -1)
    :return: inteiro ou False
    """

    a, b = 0, 0
    for i in obter_posicoes_livres(tab):
        if regra1(marcar_posicao(tab, -n, i), -n) is not False:                                     # mesmo codigo da regra3
            new_tab = marcar_posicao(marcar_posicao(tab, -n, i), n, regra1(marcar_posicao(tab, -n, i), -n))
            if regra1(new_tab, -n) is not False:
                a += 1                                                                          # o "a" conta o numero de bifurcacoes
                b = i                                                                           # "b" guarda a posicao no caso de so haver uma bifurcacao
    if a == 0:
        return False
    elif a == 1:
        return b
    if a == 2:
        if regra3(marcar_posicao(tab, -n, regra3(tab, -n)), n) is not False:                    # se depois de o adversario jogar na posicao de uma das bifurcacoes
            return regra8(tab)                                                         # continuar a haver bifurcacao, jogar na lateral para forcar o adversario a defender


def regra5(tab):
    """
    Recebe um tabuleiro e devolve a posicao livre que respeita o criterio 5, caso o
    criterio nao se verifique devolve False

    (se a posicao central estiver livre entao jogar na posicao central)

    :param tab: tabuleiro
    :return: inteiro ou False
    """

    return 5 if tab[1][1] == 0 else False


def regra6(tab, n):
    """
    Recebe um tabuleiro e um inteiro  identificando um jogador (1 para o jogador
    'X' ou -1 para o jogador 'O') e devolve a posicao livre que respeita o criterio 6, caso o
    criterio nao se verifique devolve False

    (se o adversario estiver num canto e se o canto diagonalmente oposto
    for uma posicao livre entao jogar nesse canto oposto)

    :param tab: tabuleiro
    :param n: inteiro (1 ou -1)
    :return: inteiro ou False
    """

    if obter_diagonal(tab, 1)[2] == -n and eh_posicao_livre(tab, 1):
        return 1
    if obter_diagonal(tab, 2)[0] == -n and eh_posicao_livre(tab, 3):
        return 3
    if obter_diagonal(tab, 2)[2] == -n and eh_posicao_livre(tab, 7):
        return 7
    if obter_diagonal(tab, 1)[0] == -n and eh_posicao_livre(tab, 9):
        return 9

    return False


def regra7(tab):
    """
    Recebe um tabuleiro e devolve a posicao livre que respeita o criterio 7, caso o
    criterio nao se verifique devolve False

    (se um canto for uma posicao livre entao jogar nesse canto)

    :param tab: tabuleiro
    :return: inteiro ou False
    """

    for i in [1, 3, 7, 9]:
        if i in obter_posicoes_livres(tab):
            return i
    return False


def regra8(tab):
    """
    Recebe um tabuleiro e devolve a posicao livre que respeita o criterio 8, caso o
    criterio nao se verifique devolve False

    (se uma posicao lateral (que nem e o centro, nem um canto) for livre
    entao jogar nesse lateral)

    :param tab: tabuleiro
    :return: inteiro ou False
    """

    for i in [2, 4, 6, 8]:
        if i in obter_posicoes_livres(tab):
            return i
    return False


def escolher_posicao_auto(tab, n, strat):
    """
    Recebe um tabuleiro, um inteiro identificando um jogador (1 para o jogador
    'X' ou -1 para o jogador 'O') e uma cadeia de carateres correspondente a estrategia ("basico",
    "normal" ou "perfeito", e devolve a posicao escolhida automaticamente de acordo com a estrategia seleccionada

    :param tab: tabuleiro
    :param n: inteiro
    :param strat: string
    :return: inteiro

    Erros: Se algum dos argumentos dados forem invalidos, a funcao gera um erro com a
    mensagem 'escolher_posicao_auto: algum dos argumentos e invalido'
    """

    if not eh_tabuleiro(tab) or n not in [1, -1] or type(n) != int or strat not in ["basico", "normal", "perfeito"]:
        raise ValueError("escolher_posicao_auto: algum dos argumentos e invalido")
    if strat == "basico":
        if not regra5(tab):
            if not regra7(tab):
                return regra8(tab)
            return regra7(tab)
        return regra5(tab)
    if strat == "normal":
        if not regra1(tab, n):
            if not regra2(tab, n):
                if not regra5(tab):
                    if not regra6(tab, n):
                        if not regra7(tab):
                            return regra8(tab)
                        return regra7(tab)
                    return regra6(tab, n)
                return regra5(tab)
            return regra2(tab, n)
        return regra1(tab, n)
    if strat == "perfeito":
        if not regra1(tab, n):
            if not regra2(tab, n):
                if not regra3(tab, n):
                    if not regra4(tab, n):
                        if not regra5(tab):
                            if not regra6(tab, n):
                                if not regra7(tab):
                                    return regra8(tab)
                                return regra7(tab)
                            return regra6(tab, n)
                        return regra5(tab)
                    return regra4(tab, n)
                return regra3(tab, n)
            return regra2(tab, n)
        return regra1(tab, n)


def jogo_do_galo(x, strat):
    """
    Esta funcao corresponde a funcao principal que permite jogar um jogo completo de Jogo
    do Galo de um jogador contra o computador

    A funcao recebe duas cadeias de caracteres e devolve
    o identificador do jogador ganhador ('X' ou 'O'). Em caso de empate, a funcao
    deve devolver a cadeia de caracteres 'EMPATE'. O primeiro argumento corresponde
    a marca ('X' ou 'O') que deseja utilizar o jogador humano, e o segundo argumento
    selecciona a estrategia de jogo utilizada pela maquina ("basico", "normal" ou "perfeito")

    :param x: string
    :param strat: string
    :return: string

    Erros: Se algum dos argumentos dados forem invalidos, a funcao gera um
    erro com a mensagem 'jogo_do_galo: algum dos argumentos e invalido'
    """

    def x_para0e1():
        return 1 if x == "X" else -1

    if x not in ("X", "O") or strat not in ["basico", "normal", "perfeito"]:
        raise ValueError("'jogo do galo: algum dos argumentos e invalido")

    print("Bem-vindo ao JOGO DO GALO.")
    print("O jogador joga com '" + x + "'.")

    tab, a = ((0, 0, 0), (0, 0, 0), (0, 0, 0)), 0

    if x == "X":
        a += 1

    while obter_posicoes_livres(tab) != () and jogador_ganhador(tab) == 0:
        if a % 2 == 0:                                                              # o "a" serve para conseguir alternar entre jogada do computador e jogada do jogador
            n = -x_para0e1()
            tab = marcar_posicao(tab, n, escolher_posicao_auto(tab, n, strat))
            print("Turno do computador (" + strat + "):")
            print(tabuleiro_str(tab))
            a += 1
        else:
            n = x_para0e1()
            tab = marcar_posicao(tab, n, escolher_posicao_manual(tab))
            print(tabuleiro_str(tab))
            a += 1

    if jogador_ganhador(tab) == 1:
        return "X"
    elif jogador_ganhador(tab) == -1:
        return "O"
    else:
        return "EMPATE"

