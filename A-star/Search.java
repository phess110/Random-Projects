import java.util.*;

public class Search{

	//straight line distances to Bucharest, in lexicographic order, e.g. h(Arad) = 366, h(Zerind) = 374.
	private static final int[] sld = {366, 0, 160, 242, 161, 176, 77, 151, 226, 244, 241, 234, 380, 100, 193, 253, 329, 80, 199, 374};

	static int h(Node n){
		return sld[n.idx];
	}

	static void solution(Node end, Node start){
		//backtrack through search tree from end
	}

	static void aStar(Graph g, Node start, Node end){

		Set<Node> frontierSet = new HashSet<Node>();
		Comparator<Node> comparator = new MyComparator(); 
		PriorityQueue<Node> frontier = new PriorityQueue<Node>(20, comparator);
		
		start.eval = h(start);
		frontierSet.add(start);
		frontier.add(start);
		Node explore = start;
		int count = 0;

		while(!frontierSet.isEmpty()){

			count++;
			explore = frontier.poll();
			frontierSet.remove(explore);
			explore.explored = true;

			if(explore == end){
				System.out.println("Goal reached: cost = " + explore.g);
				System.out.println("Nodes visited: " + count);
				System.out.print("Solution: ");
				break;
			}

			System.out.println("expand node: " + explore.name + " " + explore.eval);

			for(Edge e: explore.neighbors){

				Node n = e.neighbor;
				int path = e.distance + explore.g; //actual distance from start to node n
				int f = path + h(n); //estimated shortest distance from start to end through n

				if(frontierSet.contains(n)){
					if(n.eval > f){
						frontier.remove(n);
						n.g = path;
						n.eval = f;
						n.parent = explore;
						frontier.add(n);
						System.out.println("\tupdating " + n.name + " : " + path + " " + h(n) + " " + f);
					}
				}else{
					n.g = path;
					n.eval = f;
					n.parent = explore;
					frontier.add(n);
					frontierSet.add(n);
					n.parent = explore;
					System.out.println("\tadded " + n.name + " : " + path + " " + h(n) + " " + f);
				}
			}
		}
		//solution(end, start);
	}

	public static void main(String [] args){
		Node[] nodes = new Node[20];

		String [] cities = {"Arad", "Bucharest", "Craiova", "Drobeta", "Eforie", "Fagaras", "Giurgiu", "Hirsova", "Iasi", "Lugoj", "Mehadia", "Neamt", "Oradea","Pitesti", "Rimnicu V.", "Sibiu","Timisoara", "Urziceni", "Vaslui", "Zerind"};

		for(int i = 0; i < 20; i++){
			nodes[i] = new Node(cities[i], i);
		}

		nodes[0].addEdge(nodes[15], 140);
		nodes[0].addEdge(nodes[16], 118);
		nodes[0].addEdge(nodes[19], 75);

		nodes[1].addEdge(nodes[13], 101);
		nodes[1].addEdge(nodes[17], 85);
		nodes[1].addEdge(nodes[5], 211);
		nodes[1].addEdge(nodes[6],90);

		nodes[2].addEdge(nodes[3],120);
		nodes[2].addEdge(nodes[14],146);
		nodes[2].addEdge(nodes[13],138);

		nodes[3].addEdge(nodes[2],120);
		nodes[3].addEdge(nodes[10],75);

		nodes[4].addEdge(nodes[7],86);

		nodes[5].addEdge(nodes[15],99);
		nodes[5].addEdge(nodes[1],211);

		nodes[6].addEdge(nodes[1],90);

		nodes[7].addEdge(nodes[4],86);
		nodes[7].addEdge(nodes[17],98);

		nodes[8].addEdge(nodes[11],87);
		nodes[8].addEdge(nodes[18],92);

		nodes[9].addEdge(nodes[10],70);
		nodes[9].addEdge(nodes[16],111);

		nodes[10].addEdge(nodes[9],70);
		nodes[10].addEdge(nodes[3],75);

		nodes[11].addEdge(nodes[8],87);
		nodes[12].addEdge(nodes[19],71);
		nodes[12].addEdge(nodes[15],151);

		nodes[13].addEdge(nodes[2],138);
		nodes[13].addEdge(nodes[1],101);
		nodes[13].addEdge(nodes[14],97);

		nodes[14].addEdge(nodes[13],97);
		nodes[14].addEdge(nodes[2],146);
		nodes[14].addEdge(nodes[15],80);
		nodes[15].addEdge(nodes[14],80);
		nodes[15].addEdge(nodes[5],99);
		nodes[15].addEdge(nodes[0],140);
		nodes[15].addEdge(nodes[12],151);

		nodes[16].addEdge(nodes[0],118);
		nodes[16].addEdge(nodes[9],111);
		nodes[17].addEdge(nodes[1],85);
		nodes[17].addEdge(nodes[7],98);
		nodes[17].addEdge(nodes[18],142);
		nodes[18].addEdge(nodes[17],142);
		nodes[18].addEdge(nodes[8],92);
		nodes[19].addEdge(nodes[0],75);
		nodes[19].addEdge(nodes[12],71);

		Graph romania = new Graph(nodes);
		aStar(romania, nodes[9], nodes[1]);
	}
}