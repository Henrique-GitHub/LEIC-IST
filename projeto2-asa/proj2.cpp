#include <algorithm>
#include <iostream>
#include <list>
#include <vector>

int BLACK = 5;
int GRAY = 4;
int VISITED_BY_U = 1;
int VISITED_BY_V = 2;
int VISITED_BY_BOTH = 3;
int WHITE = 0;
int BANNED = -1;
int FOUND_A_CYCLE = -2;
int VALID = -3;
int MORE_THAN_2_PARENTS = -4;

class Graph {
   public:
    int num_vertices;
    std::vector<std::vector<int>> adj_list_graph;
    std::vector<std::vector<int>> adj_list_inverseGraph;

    Graph() {}

    void addEdge(int u, int v) {
        adj_list_graph[u - 1].push_back(v - 1);
        adj_list_inverseGraph[v - 1].push_back(u - 1);
    }

    bool validGenealogicalTree() {
        std::vector<int> closeOrder;
        if(dfsFindSCCs(dfsGetCloseOrder()) != VALID)
            return false;
        return true;
    }

    void createGraphWhithInput() {
        int n_vertices, n_edge;
        scanf("%d %d", &n_vertices, &n_edge);

        num_vertices = n_vertices;

        adj_list_graph = std::vector<std::vector<int>>(n_vertices);
        adj_list_inverseGraph = std::vector<std::vector<int>>(n_vertices);

        for (int i = 0; i < n_edge; i++) {
            int x, y;
            scanf("%d %d", &x, &y);
            addEdge(x, y);
        }
    }

    std::vector<int> getCommonAncestor(int u, int v) {
        std::vector<int> stack;
        std::vector<int> data(num_vertices, WHITE);
        std::vector<int> res;

        u = u - 1;
        v = v - 1;

        if (u == v) {
            res.push_back(u + 1);
            return res;
        }

        stack.push_back(u);
        data[u] = VISITED_BY_U;
        stack.push_back(v);
        data[v] = VISITED_BY_V;

        while (stack.size() != 0) {
            int current = stack[0];
            for (long unsigned i = 0; i < adj_list_inverseGraph[stack[0]].size(); i++) {
                int ancestor = adj_list_inverseGraph[stack[0]][i];

                if (data[ancestor] == WHITE) {
                    data[ancestor] = data[current];
                } else if ((data[ancestor] == VISITED_BY_U &&
                            data[current] != VISITED_BY_U) ||
                           (data[ancestor] == VISITED_BY_V &&
                            data[current] != VISITED_BY_V)) {
                    data[ancestor] = VISITED_BY_BOTH;
                    banAncestors(ancestor, &data);
                }

                if (data[ancestor] != VISITED_BY_BOTH ||
                    data[ancestor] != BANNED)
                    stack.push_back(ancestor);
            }
            stack.erase(stack.begin());
        }

        for (long unsigned i = 0; i < data.size(); i++) {
            if (data[i] == VISITED_BY_BOTH) {
                res.push_back(i + 1);
            }
        }

        return res;
    }

   private:
    void banAncestors(int u, std::vector<int>* sonsVector) {
        for (long unsigned i = 0; i < adj_list_inverseGraph[u].size(); i++) {
            int ancestor = adj_list_inverseGraph[u][i];
            (*sonsVector)[ancestor] = BANNED;
            banAncestors(ancestor, sonsVector);
        }
    }

    int dfsVisitInvese(int u, std::vector<int> *closeOrder,  std::vector<int> *color) {
        (*color)[u] = GRAY;
        if(adj_list_inverseGraph[u].size() > 2)
            return MORE_THAN_2_PARENTS;

        for(long unsigned i = 0; i < adj_list_inverseGraph[u].size(); i++) {
            int v = adj_list_inverseGraph[u][i];
            if((*color)[v] == WHITE)
                return FOUND_A_CYCLE;
        }
        (*color)[u] = BLACK;
        return VALID;
    }

    int dfsFindSCCs(std::vector<int> closeOrder) {
        std::vector<int> color((num_vertices));

        for (int i = 0; i < num_vertices; i++) {
            color[i] = WHITE;
        }

        for(int i = closeOrder.size() - 1; i >= 0; i--) {
            int status = VALID;
            if(color[closeOrder[i]] == WHITE){
                status = dfsVisitInvese(closeOrder[i], &closeOrder, &color);
                if(status != VALID){
                    return status;
                }
            }
        }
        return VALID;
    }

    void dfsVisitGetCloseOrder(int u, std::vector<int> *closeOrder,  std::vector<int> *color) {
        (*color)[u] = GRAY;
        for(long unsigned  i = 0; i < adj_list_graph[u].size(); i++) {
            int v = adj_list_graph[u][i];
            if((*color)[v] == WHITE)
                dfsVisitGetCloseOrder(v, closeOrder, color);
        }
        (*color)[u] = BLACK;
        (*closeOrder).push_back(u);
    }

    std::vector<int> dfsGetCloseOrder() {
        std::vector<int> closeOrder(num_vertices);
        std::vector<int> color(num_vertices);

        for (int i = 0; i < num_vertices; i++) {
            color[i] = WHITE;
        }

        for(int i = 0; i < num_vertices; i++) {
            if(color[i] == WHITE)
                dfsVisitGetCloseOrder(i, &closeOrder, &color);
        }

        return closeOrder;
    }
};

int main() {
    int v1, v2;
    Graph graph;
    std::vector<int> res;

    scanf("%d %d", &v1, &v2);

    graph.createGraphWhithInput();

    if(!graph.validGenealogicalTree())
        printf("0");
    else {
        res = graph.getCommonAncestor(v1, v2);

        if (res.size() == 0)
            printf("-");
        else
            for (long unsigned i = 0; i < res.size(); i++) {
                printf("%d ", res[i]);
            }
    }

    printf("\n");

    return 0;
}
