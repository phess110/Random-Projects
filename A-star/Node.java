import java.util.List;	
import java.util.ArrayList;

public class Node{
	String name;
	int idx;
	Node parent;
	int eval;
	int g;
	List<Edge> neighbors;

	Node(String s, int i){
		name = s;
		idx = i;
		parent = null;
		eval = 0;
		g = 0;
		neighbors = new ArrayList<Edge>();
	}

	//add edge from n to x with distance d
	void addEdge(Node x, int d){
		neighbors.add(new Edge(x,d));
	}
}