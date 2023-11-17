# Henrique Anjos 199081
# FP2020/2021 @ IST - Projeto 2 - Jogo do Moinho


"""
    TAD posicao

    Representacao[posicao] --> [coluna, linha]

    Uma posicao e representada por uma lista de dois inteiros, em que o 1o inteiro representa a sua coluna e o 
2o inteiro representa a sua linha. As colunas sao representadas por "a", "b" ou "c" e as linhas por "1", "2", ou "3"

"""


def cria_posicao(c, l):
    """
    Cria uma posicao

    :param: string
    :param: string
    :return: posicao

    Recebe duas strings, tendo  a primeira que ser "a", "b" ou "c" e a segunda "1", "2" ou "3", e devolve
    a posicao que representa no tabuleiro os argumentos dados. Caso os argumentos dados sejam invalidos levanta erro
    """
    if c in ("a", "b", "c") and l in ("1", "2", "3"):
        return [c, l]
    raise ValueError("cria_posicao: argumentos invalidos")


def cria_copia_posicao(p):
    """
    Recebe uma posicao p e devolve uma nova copia da posicao

    :param p: posicao
    :return: posicao
    """
    return cria_posicao(obter_pos_c(p), obter_pos_l(p))


def obter_pos_c(p):
    """
    Devolve a coluna em que se situa a posicao p

    :param p: posicao
    :return: string
    """
    return p[0]


def obter_pos_l(p):
    """
    Devolve a linha em que se situa a posicao p

    :param p: posicao
    :return: string
    """
    return p[1]


def eh_posicao(arg):
    """
    Devolve True caso o seu argumento seja um TAD posicao e False caso contrario.

    :param arg: universal
    :return: booleano
    """
    return type(arg) == list and len(arg) == 2 and obter_pos_c(arg) in ("a", "b", "c")\
        and obter_pos_l(arg) in ("1", "2", "3")


def eh_posicao_lateral(p):
    """
    Verifica se a posicao dada e uma posicao lateral

    :param p: posicao
    :return: booleano
    """
    return (int(abc_para_123(p)) + int(obter_pos_l(p))) % 2 != 0


def eh_canto(p):
    """
    Verifica se a posicao dada e um canto

    :param p: posicao
    :return: booleano
    """
    return (int(abc_para_123(p)) + int(obter_pos_l(p))) % 2 == 0 and not(abc_para_123(p) == obter_pos_l(p) == "2")


def posicoes_iguais(p1, p2):
    """
    Devolve True apenas se p1 e p2 sao posicoes e sao iguais e False caso contrario

    :param p1: posicao
    :param p2: posicao
    :return: booleano
    """
    return eh_posicao(p1) and eh_posicao(p2) and obter_pos_c(p1) == obter_pos_c(p2) \
           and obter_pos_l(p1) == obter_pos_l(p2)


def posicao_para_str(p):
    """
    Converte posicao em string

    :param p: posicao
    :return: string

    Devolve a cadeia de caracteres "cl" que representa o seu argumento,
    sendo os valores c e l as componentes coluna e linha de p
    """
    return obter_pos_c(p) + obter_pos_l(p)


def abc_para_123(p):
    """
    Transforma "a", "b" e "c" em "1", "2" e "3" respetivamente

    :param p: posicao
    :return: string

    Devolve o inteiro correspondente a coluna da posicao dada
    """
    d = {"a": "1", "b": "2", "c": "3"}
    return d[obter_pos_c(p)]


def lista_de_pos():
    """
    Devolve uma liosta com todas as posicoes

    :return: list
    """
    return [["a", "1"], ["b", "1"], ["c", "1"], ["a", "2"], ["b", "2"], ["c", "2"], ["a", "3"], ["b", "3"], ["c", "3"]]


def obter_posicoes_adjacentes(p):
    """
    Devolve as posicoes adjacentes

    :param p: posicao
    :return: tuplo de posicoes

    Devolve um tuplo com as posicoes adjacentes a posicao p de acordo com a ordem de leitura do tabuleiro
    """
    return tuple([i for i in lista_de_pos() if -2 < int(obter_pos_l(p)) - int(obter_pos_l(i)) < 2
                  and -2 < int(abc_para_123(p)) - int(abc_para_123(i)) < 2
                  and (eh_posicao_lateral(p) != eh_posicao_lateral(i) or eh_canto(p) != eh_canto(i))])


"""
    TAD peca

    Representacao[peca] --> string

    Uma peca e representada por uma sring que pode ser "X", "O", ou " "

"""


def cria_peca(s):
    """
    Devolve uma peca

    :param s: string
    :return: peca

    Consoante o argumento, que pode ser "X", "O", " " devolve "X", " " e "O" respetivamente
    """
    if s in ("X", "O", " "):
        return s
    raise ValueError("cria_peca: argumento invalido")


def cria_copia_peca(j):
    """
    Recebe uma peca e devolve uma copia nova da peca

    :param j: peca
    :return: peca
    """
    return cria_peca(j)


def eh_peca(arg):
    """
    Devolve True caso o seu argumento seja um TAD peca e False caso contrario

    :param arg: universal
    :return: booleano
    """
    return arg in (cria_peca("X"), cria_peca("O"), cria_peca(" "))


def pecas_iguais(j1, j2):
    """
    Devolve True apenas se j1 e j2 sao pecas e sao iguais

    :param j1: peca
    :param j2: peca
    :return: booleano
    """
    return eh_peca(j1) and eh_peca(j2) and j1 == j2


def peca_para_str(j):
    """
    Devolve a cadeia de caracteres que representa o jogador dono da peca, isto e, '[X]', '[O]' ou '[ ]'

    :param j: peca
    :return: string
    """
    return "[" + j + "]"


def peca_para_inteiro(j):
    """
    Devolve um inteiro valor 1, -1 ou 0, dependendo se a peca e do jogador 'X', 'O' ou livre, respetivamente

    :param j: peca
    :return:int
    """
    dic3 = {cria_peca("X"): 1, cria_peca("O"): -1, cria_peca(" "): 0}
    return dic3[j]


def inteiro_para_peca(n):
    """
    Devolve a peca correspondente ao inteiro dado

    :param n: int
    :return: peca
    """
    dic3 = {1: cria_peca("X"), -1: cria_peca("O"), 0: cria_peca(" ")}
    return dic3[n]


"""
    TAD tabuleiro

    Representacao[tabuleiro] --> [[peca, peca, peca], [peca, peca, peca], [peca, peca, peca]]

    Um tabuleiro e representado por uma lista contendo 3 listas. Todas estas 3 listas tem 3 elementos do tipo peca

"""


def cria_tabuleiro():
    """
    Cria um tabuleiro

    :return: tabuleiro

    Devolve um tabuleiro de jogo do moinho de 3x3 sem posicoes
    ocupadas por pecas de jogador.
    """
    return [[cria_peca(" ")] * 3 for i in range(3)]


def cria_copia_tabuleiro(t):
    """
    Recebe um tabuleiro e devolve uma copia nova do tabuleiro

    :param t: tabuleiro
    :return: tabuleiro
    """
    return [[cria_peca(peca) for peca in linha] for linha in t]


def tabuleiro_para_lista(t):
    """
    Devolve todas as pecas to tabuleiro numa so lista

    :param t: tabuleiro
    :return: lista
    """
    return [peca for i in t for peca in i]


def obter_peca(t, p):
    """
    Devolve a peca na posicao p do tabuleiro. Se a posicao nao
    estiver ocupada, devolve uma peca livre

    :param t: tabuleiro
    :param p: posicao
    :return: peca
    """
    return t[int(obter_pos_l(p))-1][int(abc_para_123(p))-1]


def obter_vetor(t, s):
    """
    Devolve todas as pecas da linha ou coluna especicada pelo seu argumento

    :param t: tabuleiro
    :param s: string
    :return: tuplo de pecas
    """
    if s in ("a", "b", "c"):
        return tuple([t[i][int(abc_para_123([s, ""]))-1] for i in range(3)])
    return tuple(t[int(s)-1])


def coloca_peca(t, j, p):
    """
    Modifca destrutivamente o tabuleiro t colocando a peca j
    na posicao p, e devolve o proprio tabuleiro

    :param t: tabuleiro
    :param j: peca
    :param p: posicao
    :return: tabuleiro
    """
    t[int(obter_pos_l(p))-1][int(abc_para_123(p)) - 1] = cria_peca(j)
    return t


def remove_peca(t, p):
    """
    Modifca destrutivamente o tabuleiro t removendo a peca
    da posicao p, e devolve o proprio tabuleiro

    :param t: tabuleiro
    :param p: peca
    :return: tabuleiro
    """
    t[int(obter_pos_l(p)) - 1][int(abc_para_123(p)) - 1] = cria_peca(" ")
    return t


def move_peca(t, p1, p2):
    """
    Modifca destrutivamente o tabuleiro t movendo a peca que se encontra
    na posicao p1 para a posicao p2, e devolve o proprio tabuleiro

    :param t: tabuleiro
    :param p1: posicao
    :param p2: posicao
    :return: tabuleiro
    """
    t1 = cria_copia_tabuleiro(t)
    return coloca_peca(remove_peca(t, p1), obter_peca(t1, p1), p2)


def eh_tabuleiro(arg):
    """
    Verifica se e tabuleiro

    :param arg: universal
    :return: booleano

    Devolve True caso o seu argumento seja um TAD tabuleiro e False caso contrario. Um tabuleiro valido
    pode ter um maximo de 3 pecas de cada jogador, nao pode conter mais de 1 peca mais de um jogador que do
    contrario, e apenas pode haver um ganhador em simultaneo.
    """
    return type(arg) == list and \
            len(arg) == 3 and \
            all(type(row) == list and len(row) == 3 for row in arg) and\
            all(eh_peca(p) for row in arg for p in row) and\
            abs(tabuleiro_para_lista(arg).count(cria_peca("X")) - tabuleiro_para_lista(arg).count(cria_peca("O"))) < 1\
            and tabuleiro_para_lista(arg).count(cria_peca("X")) + tabuleiro_para_lista(arg).count(cria_peca("O")) < 6\
            and len([j for i in ("1", "2", "3", "a", "b", "c") for j in (cria_peca("X"), cria_peca("O"))
                     if obter_vetor(arg, i).count(j) == 3]) < 2


def eh_posicao_livre(t, p):
    """
    Verifica se a posicao p do tabuleiro t corresponde a uma posicao livre

    :param t: tabuleiro
    :param p: posicao
    :return: booleano
    """
    return t[int(obter_pos_l(p)) - 1][int(abc_para_123(p)) - 1] == cria_peca(" ")


def tabuleiros_iguais(t1, t2):
    """
    Verifica se os tabuleiros dados sao iguais

    :param t1: tabuleiro
    :param t2: tabuleiro
    :return: booleano
    """
    return eh_tabuleiro(t1) and eh_tabuleiro(t2) and \
           all(pecas_iguais(j1, j2) for (j1, j2) in (zip(tabuleiro_para_lista(t1), tabuleiro_para_lista(t2))))


def tabuleiro_para_str(t):
    """
    Devolve a cadeia de caracteres que representa o tabuleiro

    :param t: tabuleiro
    :return: str

    EX:
       a   b   c
    1 [X]-[O]-[X]
       | \ | / |
    2 [ ]-[X]-[ ]
       | / | \ |
    3 [O]-[O]-[ ]
    """
    t = tabuleiro_para_lista(t)
    return "   a   b   c\n" + "1 " + peca_para_str(t[0]) + "-" + peca_para_str(t[1]) + "-" + peca_para_str(t[2]) + "\n" + \
           "   | \ | / |\n" + "2 " + peca_para_str(t[3]) + "-" + peca_para_str(t[4]) + "-" + peca_para_str(t[5]) + "\n" + \
           "   | / | \ |\n" + "3 " + peca_para_str(t[6]) + "-" + peca_para_str(t[7]) + "-" + peca_para_str(t[8])


def tuplo_para_tabuleiro(t):
    """
    Devolve o tabuleiro que e representado pelo tuplo t
    com 3 tuplos, cada um deles contendo 3 valores inteiros iguais a 1, -1 ou 0

    :param t: tuplo
    :return: tabuleiro
    """
    return [[inteiro_para_peca(inteiro) for inteiro in linha] for linha in t]


def obter_ganhador(t):
    """
    Verifica se ha algum jogador vencedor

    :param t: tabuleiro
    :return: peca

    Devolve uma peca do jogador que tenha as suas 3 pecas em linha na vertical ou na horizontal no tabuleiro.
    Se nao existir nenhum ganhador, devolve uma peca livre.
    """
    jogador_vencedor = [j for i in ("1", "2", "3", "a", "b", "c") for j in (cria_peca("X"), cria_peca("O"))
                        if obter_vetor(t, i).count(j) == 3]
    return cria_peca(" ") if not jogador_vencedor else jogador_vencedor[0]


def obter_posicoes_livres(t):
    """
    Devolve um tuplo com as posicoes nao ocupadas pelas pecas
    de qualquer um dos dois jogadores na ordem de leitura do tabuleiro.

    :param t: tabuleiro
    :return: tuplo de posicoes
    """
    return tuple(pos for pos in lista_de_pos() if obter_peca(t, pos) == cria_peca(" "))


def obter_posicoes_jogador(t, j):
    """
    Devolve um tuplo com as posicoes ocupadas pelas pecas j de um dos dois jogadores na ordem de leitura do tabuleiro

    :param t: tabuleiro
    :param j: peca
    :return: tuplo de posicoes
    """
    return tuple([pos for pos in lista_de_pos() if obter_peca(t, pos) == cria_peca(j)])


def eh_fase_colocacao(t):
    """
    Verifica se o jogo esta em fase de colocacao

    :param t: tabuleiro
    :return: booleano
    """
    return tabuleiro_para_lista(t).count(" ") > 3


def obter_movimento_manual(t, j):
    """
    Leitura da posicao ou movimento escolhidos pelo jogador

    :param t: tabuleiro
    :return: tuplo de posicoes

    Esta funcao realiza a leitura de uma posicao ou movimento introduzidos manualmente por um jogador e devolve
    um tuplo de posicoes que os representa.  Se o argumento dado for invalido, a funcao gera um erro.
    """
    if eh_fase_colocacao(t):
        m = input("Turno do jogador. Escolha uma posicao: ")
        if len(m) == 2 and m in [posicao_para_str(p) for p in obter_posicoes_livres(t)]:
            return cria_posicao(m[0], m[1]),
        raise ValueError("obter_movimento_manual: escolha invalida")
    else:
        m = input("Turno do jogador. Escolha um movimento: ")
        if len(m) == 4 and m[:2] in [posicao_para_str(p) for p in lista_de_pos() if p in obter_posicoes_jogador(t, j)] \
                and m[2:] in [posicao_para_str(p) for p in lista_de_pos()
                              if (eh_posicao_livre(t, p) and p in obter_posicoes_adjacentes(cria_posicao(m[0], m[1])))
                              or (p == cria_posicao(m[0], m[1]) and not any(obter_posicoes_livres(t)[i]
                                                                in obter_posicoes_adjacentes(cria_posicao(m[0], m[1]))
                                                                for i in range(len(obter_posicoes_livres(t)))))]:
            return cria_posicao(m[0], m[1]), cria_posicao(m[2], m[3])
        raise ValueError("obter_movimento_manual: escolha invalida")


def obter_movimento_auto(t, j, nivel):
    """
    Seleciona uma posicao de forma automatica.

    :param t: tabuleiro
    :param j: peca
    :param nivel: str
    :return: tuplo de posicoes

    Devolve um tuplo com a posicao ou movimento escolhidos automaticamente de acordo com o nivel seleccionado.
    Se algum dos argumentos dados forem invalidos, a funcao  gera um erro.
    """
    def regra0():
        a = [(pos_jog, pos_livre) for pos_jog in obter_posicoes_jogador(t, j)
             for pos_livre in obter_posicoes_adjacentes(pos_jog) if eh_posicao_livre(t, pos_livre)]
        return tuple(a[0]) if a else ()

    def regra1():
        a = [pos for pos in obter_posicoes_livres(t)
             if obter_ganhador(coloca_peca(cria_copia_tabuleiro(t), j, pos)) == j]
        return (a[0],) if a else ()

    def regra2():
        a = [pos for pos in obter_posicoes_livres(t)
             if obter_ganhador(coloca_peca(cria_copia_tabuleiro(t), inteiro_para_peca(-peca_para_inteiro(j)), pos)) ==
             inteiro_para_peca(-peca_para_inteiro(j))]
        return (a[0],) if a else ()

    def regra3():
        return (lista_de_pos()[4],) if eh_posicao_livre(t, lista_de_pos()[4]) else ()

    def regra4():
        a = [pos for pos in lista_de_pos() if eh_posicao_livre(t, pos) and eh_canto(pos)]
        return (a[0],) if a else ()

    def regra5():
        a = [pos for pos in lista_de_pos() if eh_posicao_livre(t, pos) and eh_posicao_lateral(pos)]
        return (a[0],) if a else ()

    if eh_fase_colocacao(t):
        for regra in (regra1, regra2, regra3, regra4, regra5):
            if regra():
                return regra()

    if nivel == "facil":
        return regra0()
    elif nivel == "normal":
        return cria_posicao(minimax(t, j, 1, ())[1][0][0], minimax(t, j, 1, ())[1][0][1]),\
               cria_posicao(minimax(t, j, 1, ())[1][1][0], minimax(t, j, 1, ())[1][1][1])
    elif nivel == "dificil":
        return cria_posicao(minimax(t, j, 5, ())[1][0][0], minimax(t, j, 5, ())[1][0][1]),\
                cria_posicao(minimax(t, j, 5, ())[1][1][0], minimax(t, j, 5, ())[1][1][1])


def minimax(t, j, prof, sm):
    """
    Funcao recursiva que calcula a melhor sequencia de movimentos para a peca j no tabuleiro t.

    :param t: tabuleiro
    :param j: peca
    :param prof: int
    :param sm: tuplo
    :return: tuplo

    A funcao explora todos os movimentos legais desse jogador chamando a funcao recursiva com o
    tabuleiro modicado com um dos movimentos e o jogador adversario como novos parametros. No caso geral, o
    algoritmo escolhera/devolvera o movimento que mais favoreca o jogador do turno atual.
    A recursao fializa quando existe um ganhador ou quando se atinge um nivel maximo
    de profundidade da recursao. O valor que devolve a funcao e o valor do estado do
    tabuleiro para cada jogador, sendo positivo para estados de tabuleiro que favorecam ao
    jogador 'X' e negativo se favorecem ao jogador 'O'.
    """
    if obter_ganhador(t) != cria_peca(" ") or prof == 0:
        return peca_para_inteiro(obter_ganhador(t)), sm
    melhor_res = -peca_para_inteiro(cria_peca(j))
    melhor_seq_mov = ()
    for p_jog in obter_posicoes_jogador(t, j):
        for p_adj in obter_posicoes_adjacentes(p_jog):
            if p_adj in obter_posicoes_livres(t):
                t1 = cria_copia_tabuleiro(t)
                move_peca(t1, p_jog, p_adj)
                novo_res, nova_seq_mov = minimax(t1, inteiro_para_peca(-peca_para_inteiro(cria_peca(j))), prof - 1,
                                                 sm + (posicao_para_str(p_jog), posicao_para_str(p_adj)))
                if melhor_seq_mov == () or (pecas_iguais(cria_peca("X"), j) and novo_res > melhor_res) \
                        or (pecas_iguais(cria_peca("O"), j) and novo_res < melhor_res):
                    melhor_res, melhor_seq_mov = novo_res, nova_seq_mov
    return melhor_res, melhor_seq_mov


def moinho(humano, nivel):
    """
    Funcao principal do jogo do moinho

    :param humano: str
    :param nivel: str
    :return: str

    Funcao principal que permite jogar um jogo completo de Jogo do Moinho de um jogador contra o computador.
    Recebe duas cadeias de caracteres e devolve o identificador do jogador ganhador ('X' ou 'O').
    O primeiro argumento corresponde a ([X] ou [O]) que e a peca que deseja utilizar o jogador humano,
    e o segundo argumento seleciona o nivel de jogo utilizada pela maquina. Se algum dos argumentos forem
    invalidos, gera um erro.
        """
    if humano not in (peca_para_str(cria_peca("X")), peca_para_str(cria_peca("O"))) \
            or nivel not in ("facil", "normal", "dificil"):
        raise ValueError("moinho: argumentos invalidos")

    t = cria_tabuleiro()
    jogador = 1
    print("Bem-vindo ao JOGO DO MOINHO. Nivel de dificuldade", nivel + ".")
    print(tabuleiro_para_str(t))

    humano = 1 if humano == peca_para_str(cria_peca("X")) else -1

    while obter_ganhador(t) == cria_peca(" "):
        if humano == jogador:
            p = obter_movimento_manual(t, inteiro_para_peca(jogador))
        else:
            print("Turno do computador (" + nivel + "):")
            p = obter_movimento_auto(t, inteiro_para_peca(jogador), nivel)

        if len(p) == 1:
            coloca_peca(t, inteiro_para_peca(jogador), p[0])
        else:
            move_peca(t, p[0], p[1])

        print(tabuleiro_para_str(t))
        jogador = -jogador

    if obter_ganhador(t) == cria_peca("X"):
        return "[X]"
    elif obter_ganhador(t) == cria_peca("O"):
        return "[O]"
