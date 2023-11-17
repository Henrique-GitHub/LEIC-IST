/* 
 * Henrique Anjos 99081 LEIC-T - IAED2020/2021 @ IST
 * PROJETO 1 - Sistema de gestao de tarefas tipo kanban
*/
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

/*Constantes*/
#define MAX_STR_DES 51
#define MAX_STR_ATI 21
#define MAX_STR_UTI 21
#define MAX_ATI 10
#define MAX_UTI 50
#define MAXTAREFAS 10000

#define TO_DO "TO DO"
#define IN_PROGRESS "IN PROGRESS"
#define DONE "DONE"

/*Variaveis globais*/
int instante = 0, usercount = 0, index = 0, atividadesindex = 3;

char userlist[MAX_UTI][MAX_STR_UTI], atividades[MAX_ATI][MAX_STR_ATI] = {TO_DO, IN_PROGRESS, DONE};

typedef struct tarefa{
	int id;
	int instante;
	int duracaopre;
	char descricao[MAX_STR_DES];
	char atividade[MAX_STR_ATI];
	char utilizador[MAX_STR_UTI];
}tarefa;

tarefa cofre[MAXTAREFAS], aux[MAXTAREFAS], cofre_ord[MAXTAREFAS];

/*Algoritmos de ordenacao merge, um para numeros e um para strings*/
void merge(tarefa array[], int l, int m, int r){
    int i, j, k;
    for (i = m+1; i > l; i--) aux[i-1] = array[i-1];
    for (j = m; j < r; j++) aux[r+m-j] = array[j+1];
    for (k = l; k <= r; k++){
        if (aux[j].instante < aux[i].instante) array[k] = aux[j--];
        else array[k] = aux[i++];
    }
}

void merge_strings(tarefa array[], int l, int m, int r){
    int i, j, k;
    for (i = m+1; i > l; i--) aux[i-1] = array[i-1];
    for (j = m; j < r; j++) aux[r+m-j] = array[j+1];
    for (k = l; k <= r; k++){
        if (strcmp(aux[j].descricao, aux[i].descricao) < 0) array[k] = aux[j--];
        else array[k] = aux[i++];
    }
}

void mergesort(tarefa array[], int l, int r, int a){
    int m = (r+l)/2;
    if (r <= l) return;
    if(a == 1){
    	mergesort(array, l, m, a);
    	mergesort(array, m+1, r, a);
    	merge(array, l, m, r);
    }
    else{
    	mergesort(array, l, m, a);
    	mergesort(array, m+1, r, a);
    	merge_strings(array, l, m, r);
    }
}

void t(){
	/*Adiciona uma nova tarefa ao sistema

    Formato de entrada: t <duração> <descrição>
    Formato de saída: task <id> onde <id> é o identificador da tarefa criada.
    Nota: a descrição pode conter carateres brancos.
    Erros:
	too many tasks no caso de a tarefa, se criada, exceder o limite máximo 
	de tarefas permitidas pelo sistema.
	duplicate description no caso de já existir uma tarefa com o mesmo nome.
	invalid duration no caso de a duração não ser um número positivo.
*/
	int d, i, var = 0;
	char des[MAX_STR_DES];

	scanf(" %d %50[^\n]", &d, des);

	for (i = 0; i<index; i++){
		if (!strcmp(cofre[i].descricao, des)){
			var = 1;
			break;
		}
	}
	if (index + 1 > MAXTAREFAS) printf("too many tasks\n");
	else if(var){
		printf("duplicate description\n");

	}
	else if (d <= 0) printf("invalid duration\n");
	else{
		cofre[index].duracaopre = d;
		cofre[index].instante = 0;
		cofre[index].id = index + 1;
		strcpy(cofre[index].descricao, des);
		strcpy(cofre[index].atividade, TO_DO);
		printf("task %d\n", cofre[index].id);
		index++;
	}
}

void l(){
	/*Lista as tarefas:

    Formato de entrada: l [<id> <id> ...]
    Formato de saída: <id> <actividade> #<duração> <descrição> 
    por cada tarefa, uma por linha.
        Se o comando for invocado sem argumentos, todas as tarefas
	são listadas por ordem alfabética da descrição.
        Se o comando for invocado com uma lista de <id>s, as tarefas 
	devem ser listadas pela ordem dos respetivos <id>s.
    Erros: 
    	<id>: no such task no caso de não existir a tarefa indicada.
*/
	int  a, i, id;

	a = getchar();

	if (a == ' '){
		while (a == ' '){
			scanf("%d", &id);
			if (id > index || id < 1) printf("%d: no such task\n", id);
			else printf("%d %s #%d %s\n", cofre[id-1].id, cofre[id-1].atividade, 
				    cofre[id-1].duracaopre, cofre[id-1].descricao);
			a = getchar();
		}

	}
	else{
		for (i = 0; i < index + 1; i++) cofre_ord[i] = cofre[i];
		mergesort(cofre_ord, 0, index - 1, 0);
		for (i = 0; i<index; i++){
			printf("%d %s #%d %s\n", cofre_ord[i].id, cofre_ord[i].atividade, 
			       cofre_ord[i].duracaopre, cofre_ord[i].descricao);
		}
	}
}

void n(){
	/*Avança o tempo do sistema:

    Formato de entrada: n <duração>
    Formato de saída: <instante> onde <instante> é novo valor do tempo atual.
    Nota: uma <duração> de zero permite saber o tempo atual sem o alterar.
    Erros: 
    	invalid time se a <duração> não for um inteiro decimal não negativo.
*/
    int inst, a;

    scanf(" %d", &inst);

    a = getchar();

    if (inst < 0 || a != '\n') printf("invalid time\n");
    else{
        instante += inst;
        printf("%d\n", instante);
    }
}

void u(){
	/*Adiciona um utilizador ou lista todos os utilizadores:

    Formato de entrada: u [<utilizador>]
    Formato de saída: lista dos nomes dos utilizadores, um nome por linha, 
    pela ordem de criação ou nada, se for criado um novo utilizador.
    Erros:
        user already exists no caso de já existir um utilizador com esse nome.
        too many users no caso de o novo utilizador, a ser criado, 
	exceda o limite de utilizadores.
*/
	int i, a, var = 0, var2 = 0;
	char utilizador[MAX_STR_UTI];

	a = getchar();

	if (a == ' '){
		scanf("%20s", utilizador);
		if (usercount == 50) var = 1;
		for (i = 0; i < usercount; i++){
			if (!strcmp(utilizador, userlist[i])){
				var2 = 1;
				break;
			}
		}
		if (var) printf("too many users\n");
		else if (var2) printf("user already exists\n");
		else{
			strcpy(userlist[usercount], utilizador);
			usercount += 1;
		}
	}
	else for (i = 0; i < usercount; i++) printf("%s\n", userlist[i]);
}

void m(){
	/*Move uma tarefa de uma atvidade para outra:

    Formato de entrada: m <id> <utilizador> <atividade>
    Formato de saída: duration=<gasto> slack=<slack> onde <gasto> é o tempo que a 
    tarefa gastou desde que saiu de atividade TO DO até atingir a atividade DONE e 
    <slack> é a diferença entre o tempo <gasto> e o tempo previsto (indicado na 
    criação da tarefa); se a <atividade> não for DONE, nada deve ser impresso, exceto erro.
    Nota: Uma vez iniciada uma tarefa, e registado o seu instante de início, a 
    tarefa não pode ser reiniciada; no entanto, uma tarefa dada como concluída pode 
    ser movida para uma atividade que não TO DO, para a resolução de problemas entretanto 
    encontrados, por exemplo.
    Erros:
        no such task no caso de não existir nenhuma tarefa com o identificador indicado.
        task already started no caso se tentar mover a tarefa para a atividade TO DO.
        no such user no caso de não existir nenhum utilizador com o nome indicado.
        no such activity no caso de não existir nenhuma atividade com o nome indicado.
*/
	int id, var = 1, var2 = 1, i;
	char utilizador[MAX_STR_UTI], atividade[MAX_STR_ATI];

	scanf("%d %s %20[^\n]", &id, utilizador, atividade);

	for (i = 0; i < usercount; i++){
		if (!strcmp(utilizador, userlist[i])){
			var = 0;
			break;
		}
	}
	for (i = 0; i < atividadesindex; i++){
		if (!strcmp(atividade, atividades[i])){
			var2 = 0;
			break;
		}
	}
	if (id > index || id < 1) printf("no such task\n");
	else if  (!strcmp(atividade, TO_DO) 
		  && strcmp(cofre[id-1].atividade, TO_DO)) printf("task already started\n");
	else if (var) printf("no such user\n");
	else if (var2) printf("no such activity\n");
	else{
		if (!strcmp(cofre[id-1].atividade, TO_DO)) cofre[id-1].instante = instante;
		strcpy(cofre[id-1].atividade, atividade);
		if (!strcmp(atividade, DONE)) printf("duration=%d slack=%d\n", instante - cofre[id -1].instante, 
						     instante - cofre[id -1].instante - cofre[id -1].duracaopre);
	}
}

void d(){
	/*Lista todas as tarefas que estejam numa dada atividade:

    Formato de entrada: d <atividade>:
    Formato de saída: <id> <início> <descrição> por cada tarefa que está na atividade, uma por linha, 
    por ordem crescente de instante de início (momento em que deixam a atividade TO DO) e alfabeticamente 
    por descrição, se duas ou mais tarefas tiverem o mesmo instante de início.
    Erros:
        no such activity no caso de não existir nenhuma atividade com esse nome.
*/
	char atividade[MAX_STR_ATI];
	int i, var = 1;

	scanf(" %20[^\n]", atividade);

	for (i = 0; i <= atividadesindex; i++){
		if (!strcmp(atividades[i], atividade)){
			var = 0;
			break;
		}
	}
	if (var) printf("no such activity\n");
	else{
		for (i = 0; i < index + 1; i++) cofre_ord[i] = cofre[i];
		mergesort(cofre_ord, 0, index - 1, 0);
		mergesort(cofre_ord, 0, index - 1, 1);
		for (i = 0; i < index + 1; i++){
			if (!strcmp(cofre_ord[i].atividade, atividade))	
				printf("%d %d %s\n", cofre_ord[i].id, cofre_ord[i].instante, cofre_ord[i].descricao);
		}
	}
}

void a(){
	/*Adiciona uma atividade ou lista todas as atividades:

    Formato de entrada: a [<atividade>]
    Formato de saída: lista de nomes de atividades por ordem de criação, uma por linha, ou nada, 
    se for a criação de uma nova atividade (exceto erro).
    Erros:
        duplicate activity no caso de já existir uma atividade com o mesmo nome.
        invalid description no caso de o nome da atividade conter letras minúsculas.
        too many activities no caso da atividade, se criada, exceder o limite permitido de atividades.
*/
	char atividade[MAX_STR_ATI];
	int i, a, var = 0, var2 = 0;

	a = getchar();

	if (a == ' '){
		scanf("%20[^\n]", atividade);


		for (i = 0; i<= atividadesindex; i++){
			if (!strcmp(atividades[i], atividade)){
				var = 1;
				break;
			}
		}
		for (i = 0; atividade[i]; i++){
			if (atividade[i]>= 'a' && atividade[i]<= 'z'){
				var2 = 1;
				break;
			}
		}
		if (var) printf("duplicate activity\n");
		else if (var2) printf("invalid description\n");
		else if (atividadesindex > 9) printf("too many activities\n");
		else{
			strcpy(atividades[atividadesindex], atividade);
			atividadesindex++;
		}
	}
	else for (i = 0; i < atividadesindex; i++) printf("%s\n", atividades[i]);
}

int main(){
	/*Chama as funcoes consoante o comando*/
	char c;

	c = getchar();
	while(c!='q'){
		switch(c){
			case 't':
				t();
				break;
			case 'l':
				l();
				break;
			case 'n':
				n();
				break;
			case 'u':
				u();
				break;
			case 'm':
				m();
				break;
			case 'd':
				d();
				break;
			case 'a':
				a();
				break;
		}
		c = getchar();
	}
	return 0;
}
