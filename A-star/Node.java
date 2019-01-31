import java.util.List;	
import java.util.ArrayList;

public class Node{
	private String name;
	private int idx;
	List<Edge> neighbors;

	Node(String s, int i){
		name = s;
		idx = i;
		neighbors = new ArrayList<Edge>();
	}

	//add edge from n to x with distance d. Assumes undirected graph.
	void addEdge(Node x, int d){
		neighbors.add(new Edge(x,d));
		x.neighbors.add(new Edge(this,d));
	}

	String getName(){
		return name;
	}

	int getIndex(){
		return idx;
	}
}