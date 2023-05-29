class UnionFind {
  late List<int> parent;
  late List<int> rank;

  UnionFind(int size) {
    parent = List<int>.generate(size, (index) => index);
    rank = List<int>.filled(size, 0);
  }

  int find(int x) {
    if (parent[x] != x) {
      parent[x] = find(parent[x]);
    }
    return parent[x];
  }

  void union(int x, int y) {
    int rootX = find(x);
    int rootY = find(y);

    if (rank[rootX] < rank[rootY]) {
      parent[rootX] = rootY;
    } else if (rank[rootX] > rank[rootY]) {
      parent[rootY] = rootX;
    } else {
      parent[rootY] = rootX;
      rank[rootX]++;
    }
  }
}

class Edge {
  int src, dest, weight;

  Edge(this.src, this.dest, this.weight);
}

class Graph {
  late int vertices;
  late List<Edge> edges;

  Graph(int v) {
    vertices = v;
    edges = [];
  }

  void addEdge(int src, int dest, int weight) {
    edges.add(Edge(src, dest, weight));
  }

  List<Edge> kruskalMST() {
    List<Edge> result = [];
    edges.sort((a, b) => a.weight.compareTo(b.weight));
    UnionFind uf = UnionFind(vertices);

    int i = 0;
    int e = 0;
    while (e < vertices - 1) {
      Edge nextEdge = edges[i++];
      int x = uf.find(nextEdge.src);
      int y = uf.find(nextEdge.dest);

      if (x != y) {
        result.add(nextEdge);
        uf.union(x, y);
        e++;
      }
    }

    return result;
  }
}

void main() {
  Graph graph = Graph(4);
  graph.addEdge(0, 1, 10);
  graph.addEdge(0, 2, 6);
  graph.addEdge(0, 3, 5);
  graph.addEdge(1, 3, 15);
  graph.addEdge(2, 3, 4);

  List<Edge> mst = graph.kruskalMST();
  print("Edges in MST:");
  for (Edge edge in mst) {
    print("${edge.src} -- ${edge.dest}  Weight: ${edge.weight}");
  }
}
