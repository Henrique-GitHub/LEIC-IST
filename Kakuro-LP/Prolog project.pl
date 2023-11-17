%Henrique Anjos 99081
%Logica de Programacao - 2020/2021

:- [codigo_comum].

%------------------------------------------------------------------------------
%				Predicado 3.1.1 - combinacoes_soma/4
%
%     combinacoes_soma(N, Els, Soma, Combs)
%          -Recebe um inteiro(N), uma lista de inteiros(Els) e outro inteiro(Soma)
%          -Devolve uma lista ordenada cujos elementos sao as combinacoes N a N, 
%			dos elementos de Els cuja soma eh Soma
%------------------------------------------------------------------------------

combinacoes_soma(N, Els, Soma, Combs):-
	bagof(Comb, (combinacao(N, Els, Comb),sumlist(Comb, Soma)), Combs).


%------------------------------------------------------------------------------
%				Predicado 3.1.2 - permutacoes_soma/4
%
%     permutacoes_soma(N, Els, Soma, Perms)
%          -Recebe um inteiro(N), uma lista de inteiros(Els) e outro inteiro(Soma)
%          -Devolve uma lista ordenada cujos elementos sao as permutacoes das 
%			combinacoes N a N, dos elementos de Els cuja soma eh Soma
%------------------------------------------------------------------------------

permutacoes_soma(N, Els, Soma, Perms):-
	findall(L, (combinacao(N, Els, Comb), permutation(Comb, L), sumlist(L, Soma)), Perm),
	sort(Perm, Perms).


%------------------------------------------------------------------------------
%				Predicado 3.1.3 - espaco_fila/2
%
%     espaco_fila(Fila, Esp, H_V)
%          -Fila eh uma fila (linha ou coluna) de um puzzle e H_V eh um dos atomos
%			h ou v, conforme se trate de uma fila horizontal ou vertical
%          -Devolve todos os espacos de Fila, um de cada vez 
%------------------------------------------------------------------------------

espaco_fila(Lst, X, H_V):-			% utiliza o predicado 3.1.4
	espacos_fila(H_V, Lst, Esps),	% da return a todos os elementos da
	member(X, Esps).				% lista feita pelo predicado 3.1.4


%------------------------------------------------------------------------------
%				Predicado 3.1.4 - espacos_fila/2
%
%     espacos_fila(H_V, Fila, Espacos)
%          -Fila eh uma fila (linha ou coluna) de um puzzle e H_V eh um dos atomos
%			h ou v, conforme se trate de uma fila horizontal ou vertical
%          -Devolve uma lista de todos os espacos de Fila, da esquerda para a direita
%------------------------------------------------------------------------------

espacos_fila(_, [], []).
espacos_fila(H_V, Lst, [espaco(Elem, Esp1)|Tail]) :-
	elimina(Lst, NovaLista),
	elimina_listas_seguidas(NovaLista, NovaLista1),
    help(NovaLista1, Lst2, H_V, Elem),
    espacos_fila_aux(Lst2, Esp1, Resto),
    espacos_fila(H_V, Resto, Tail),!.

elimina_aux(El):- 
    is_list(El),		% verifica se El eh uma lista composta apenas por zeros
    sumlist(El,0).    

elimina(Fila,NovaFila):-
    exclude(elimina_aux,Fila,NovaFila). % elimina os elementos [0,0] da lista Fila

elimina_listas_seguidas([H,H2|NovaLista], [H,H2|NovaLista]):-	% funcao auxiliar que elimina
	var(H).														% a primeira de 2 listas seguidas
elimina_listas_seguidas([H,H2|NovaLista], [H,H2|NovaLista]):-
	var(H2).
elimina_listas_seguidas([H,H2|NovaLista], [H2|NovaLista]):-
	is_list(H),
	is_list(H2).


help([], _, _, _).
help([H|T], T, H_V, Elem) :-		% funcao auxiliar que devolve o Elem, consoante H_V
    is_list(H),						% tambem devolve T, que eh a fila sem o seu 1o elemento
    H_V = v,						% se este for uma lista diferente de [0,0]
    nth1(1, H, Elem).

help([H|T], T, H_V, Elem) :-
    is_list(H),
    H_V = h,
    nth1(2, H, Elem).

espacos_fila_aux([], [], _).					% funcao auxiliar que ajuda a guardar as
espacos_fila_aux([H|T], [H|Lista], Resto) :-	% variaveis 
	var(H),
    espacos_fila_aux(T, Lista, Resto).

espacos_fila_aux([H|T], Lista, Resto) :-
	is_list(H),
	Lista = [],
	Resto = [H|T],!.


%------------------------------------------------------------------------------
%				Predicado 3.1.6 - espacos_com_posicoes_comuns/3
%
%     espacos_com_posicoes_comuns(Espacos, Esp, Esps_com)						
%          -Recebe uma lista de espacos e um espaco(Esp)
%          -Devolve a lista de espacos com variaveis em comum com Esp,
%			exceptuando Esp
%------------------------------------------------------------------------------

espacos_com_posicoes_comuns(Espacos,Esp,Esps_com):-
    espacos_com_posicoes_comuns_aux(Espacos,Esp,[],Esps_com),!.

espacos_com_posicoes_comuns_aux([],_,List_Aux,Esps_com):-
    reverse(List_Aux,Esps_com).
espacos_com_posicoes_comuns_aux([H|Espacos],Esp,List_Aux,Esps_com):-
    H == Esp,
    espacos_com_posicoes_comuns_aux(Espacos,Esp,List_Aux,Esps_com).				
espacos_com_posicoes_comuns_aux([H|Espacos],Esp,List_Aux,Esps_com):-
	H = espaco(_, Lista_Vars),
	Esp = espaco(_, Lista_Vars1),
	common_elem(Lista_Vars, Lista_Vars1),
    espacos_com_posicoes_comuns_aux(Espacos,Esp,[H|List_Aux],Esps_com).
espacos_com_posicoes_comuns_aux([_|Espacos],Esp,List_Aux,Esps_com):-
    espacos_com_posicoes_comuns_aux(Espacos,Esp,List_Aux,Esps_com).

common_elem([H|_], L2) :-
    membro(H, L2).
common_elem([_|T], L2) :-	% funcao auxiliar que ve se duas listas
    common_elem(T, L2).		% tem elementos em comum

membro(X, [H|_]) :-
    X == H.
membro(X, [_|T]) :-
    membro(X, T).


%------------------------------------------------------------------------------
%				Predicado 3.1.7 - permutacoes_soma_espacos/2
%
%     permutacoes_soma_espacos(Espacos, Perms_soma)
%          -Recebe uma lista de espacos
%          -Devolve uma lista de listas de 2 elementos, em que
%			o 1o elemento eh um espaco de Espacos e o 2o eh a lista ordenada de 
%			permutacoes cuja soma eh igual a soma do espaco.
%------------------------------------------------------------------------------

permutacoes_soma_espacos([],[]).
permutacoes_soma_espacos([H|Espacos], [H1|Perms_soma]):-
	permutacoes_soma_espacos_aux(H, H1),
	permutacoes_soma_espacos(Espacos, Perms_soma).

permutacoes_soma_espacos_aux(H, [H,Perms]):-
	H = espaco(Soma, Lista_Vars),
	length(Lista_Vars, Length_List),
	permutacoes_soma(Length_List, [1,2,3,4,5,6,7,8,9], Soma, Perms).


%------------------------------------------------------------------------------
%				Predicado 3.1.11 - numeros_comuns/2
%
%     numeros_comuns(Lst_Perms, Numeros_comuns)
%          -Recebe uma lista de permutacoes
%          -Devolve uma lista de pares (pos, numero), significando que todas as 
%			listas de Lst_Perms contem o numero numero na posicao pos.
%------------------------------------------------------------------------------

numeros_comuns(Lst_Perms, Numeros_comuns):-
	findall((N, X), numeros_comuns_aux(Lst_Perms, N, X), Numeros_comuns).

numeros_comuns_aux([], _, _).
numeros_comuns_aux([Head|Tail], N, X):-
	nth1(N, Head, X),
	numeros_comuns_aux(Tail, N, X).


%------------------------------------------------------------------------------
%				Predicado 3.1.12 - atribui_comuns/1
%
%     atribui_comuns(Perms_Possiveis)
%          -Recebe uma lista de permutacoes possiveis
%          -Atualiza esta lista atribuindo a cada espaco numeros comuns
%			a todas as permutacoes possiveis para esse espaco
%------------------------------------------------------------------------------

atribui_comuns([]).
atribui_comuns([H|T]):-
    procura_numeros(H),
    atribui_comuns(T).

procura_numeros(Perm):-
    nth1(1, Perm,Esp),
    nth1(2, Perm,Perms),
    numeros_comuns(Perms, Numeros_comuns),
    substitui_numeros(Esp, Numeros_comuns).

substitui_numeros(_, []).
substitui_numeros(Esp, [H|T]):-		%substitui numeros comuns no espaco
    (Pos, Numero) = H,
    nth1(Pos, Esp, Numero),
    substitui_numeros(Esp, T).


%------------------------------------------------------------------------------
%				Predicado 3.1.13 - retira_impossiveis/2
%
%     retira_impossiveis(Perms_Possiveis, Novas_Perms_Possiveis)
%          -Recebe uma lista de permutacoes possiveis
%          -Devolve uma lista resultante de tirar todas as permutacoes 
%			impossiveis de Perms_Possiveis
%------------------------------------------------------------------------------

retira_impossiveis([], []).
retira_impossiveis([Head|Tail], [NewHead|Tail2]):-
	retira_imp(Head, NewHead),
	retira_impossiveis(Tail, Tail2).

retira_imp([Head|[Tail]], [Head|[Novas_Perms_Possiveis]]):-
	retira(Head, Tail, Novas_Perms_Possiveis).

retira(_, [], []).
retira(H, [Head|T], [Head|Tail]):-
	unifiable(H, Head, _), !,
	retira(H, T, Tail).

retira(H, [_|T], Tail) :-
    retira(H, T, Tail).


%------------------------------------------------------------------------------
%				Predicado 3.1.14 - simplifica/2
%
%     escolhe_menos_alternativas(Perms_Possiveis, Escolha)
%          -Recebe uma lista de permutacoes possiveis
%          -Devolve o resultado de simplificar Perms_Possiveis, para simplificar 
%			uma lista de permutacoes possiveis, deve aplicar-lhe os predicados 
%			atribui_comuns e retira_impossiveis, por esta ordem, ate nao haver 
%			mais alteracoes.
%------------------------------------------------------------------------------

simplifica(Perms_Possiveis, Novas_Perms_Possiveis):-
    atribui_comuns(Perms_Possiveis),
    retira_impossiveis(Perms_Possiveis, Perms_sem_impossiveis),    
    Perms_sem_impossiveis \== Perms_Possiveis,
    simplifica(Perms_sem_impossiveis, Novas_Perms_Possiveis).
simplifica(Perms_Possiveis, Novas_Perms_Possiveis):-
    atribui_comuns(Perms_Possiveis),
    retira_impossiveis(Perms_Possiveis, Novas_Perms_Possiveis),    
    Novas_Perms_Possiveis == Perms_Possiveis, !.


%------------------------------------------------------------------------------
%				Predicado 3.2.1 - escolhe_menos_alternativas/2
%
%     escolhe_menos_alternativas(Perms_Possiveis, Escolha)
%          -Recebe uma lista de permutacoes possiveis
%          -Devolve o elemento com menos permutacoes de Perms_Possiveis
%			desde que tenha pelo menos duas, se houver varios devolve o 1o a
%			aparecer em Perms_Possiveis.
%------------------------------------------------------------------------------

escolhe_menos_alternativas(Perms_Possiveis, Escolha):-
    escolhe_menos_alternativas(Perms_Possiveis, 99, [], Escolha),!.
escolhe_menos_alternativas([],_,Escolha,Escolha):-
    Escolha \== [].
escolhe_menos_alternativas([Esp_Perms|Perms_Possiveis], N, Escolha_2, Escolha):-
    nth1(2,Esp_Perms,Perms),
    length(Perms,Perms_l),
    Perms_l =< 1,
    escolhe_menos_alternativas(Perms_Possiveis,N,Escolha_2,Escolha).
escolhe_menos_alternativas([Esp_Perms|Perms_Possiveis],N, Escolha_2, Escolha):-
    nth1(2,Esp_Perms,Perms),
    length(Perms,Perms_l),
    Perms_l >= N,
    escolhe_menos_alternativas(Perms_Possiveis,N,Escolha_2,Escolha).
escolhe_menos_alternativas([Esp_Perms|Perms_Possiveis],N, _, Escolha):-
    nth1(2,Esp_Perms,Perms),
    length(Perms,Perms_l),
    Perms_l < N,
    Perms_l > 1,
    escolhe_menos_alternativas(Perms_Possiveis,Perms_l,Esp_Perms,Escolha).


%------------------------------------------------------------------------------
%				Predicado 3.2.2 - experimenta_pal/3
%
%     experimenta_perm(Escolha, Perms_Possiveis, Novas_Perms_Possiveis).
%          -Recebe uma lista de permutacoes possiveis e um dos seus elementos(Escolha)
%          -Novas_Perms_Possiveis eh o resultado de substituir, em Perms_Possiveis, o
%			elemento Escolha pelo elemento [Esp, [Perm]]
%------------------------------------------------------------------------------

experimenta_perm(Escolha, Perms_Possiveis, Novas_Perms_Possiveis):-
    nth1(1, Escolha, Esp),
    nth1(2 ,Escolha, Perms),
    member(Perm, Perms),
    Esp = Perm,											% troca Escolha por [Esp, [Perm]]
    select(Escolha, Perms_Possiveis, [Esp,[Perm]], Novas_Perms_Possiveis).


%------------------------------------------------------------------------------
%				Predicado 3.2.3 - resolve_aux/2
%
%     escolhe_menos_alternativas(Perms_Possiveis, Escolha)
%          -Recebe uma lista de permutacoes possiveis
%          -Devolve o resultado de aplicar o algoritmo descrito na Seccao
%			2.2 a Perms_Possiveis
%------------------------------------------------------------------------------

resolve_aux(Perms_Possiveis, Novas_Perms_Possiveis):-
    escolhe_menos_alternativas(Perms_Possiveis, Escolha),
    experimenta_perm(Escolha, Perms_Possiveis, Perms_Possiveis_com_escolha),
    simplifica(Perms_Possiveis_com_escolha, Perm_Possiveis_simplificado),
    resolve_aux(Perm_Possiveis_simplificado, Novas_Perms_Possiveis),!.
resolve_aux(Perms_Possiveis, Novas_Perms_Possiveis):-
    Novas_Perms_Possiveis = Perms_Possiveis,!.


