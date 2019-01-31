import java.util.PriorityQueue;
import java.util.Comparator;

public class Search{

	//straight line distances to Bucharest, in lexicographic order, e.g. h(Arad) = 366, h(Zerind) = 374.
	private static final int[] sld = {366, 0, 160, 242, 161, 176, 77, 151, 226, 244, 241, 234, 380, 100, 193, 253, 329, 80, 199, 374};

	static int h(Node n){
		return sld[n.getIndex()];
	}

	static void solution(Tree end, Tree start){
		if(end.equals(start)){
			System.out.print(end.getCityName() + " ");
		}
		else{
			solution(end.parent, start);
			System.out.print(end.getCityName() + " ");
		}
	}

	static void aStar(Node start, Node end){

		MySet<Tree> frontierSet = new MySet<Tree>();
		Comparator<Tree> comparator = new MyComparator(); 
		PriorityQueue<Tree> frontier = new PriorityQueue<Tree>(20, comparator);

		Tree search = new Tree(null, start);

		search.setEstTotal(h(start)); //heuristic
		frontierSet.add(search);
		frontier.add(search);

		Tree explore = search;
		int count = 0;

		while(!frontierSet.isEmpty()){

			explore = frontier.poll();
			frontierSet.remove(explore.getCity());

			if(explore.getCity() == end){
				System.out.println("Goal reached. Cost = " + explore.getTrueCost());
				System.out.println("Nodes visited: " + count);
				System.out.print("Solution: ");
				break;
			}

			count++;
			System.out.println("expand node: " + explore.getCityName() + " " + explore.getEstTotal());

			for(Edge e: explore.getCity().neighbors){

				Node n = e.neighbor;
				int newTrueCost = e.distance + explore.getTrueCost(); //actual distance from start to node n
				int newEstTotal = newTrueCost + h(n); //estimated shortest distance from start to end through n

				if(frontierSet.contains(n)){
					Tree child = frontierSet.remove(n);
					if(child.getEstTotal() > newEstTotal){
						frontier.remove(child);
						child.setTrueCost(newTrueCost);
						child.setEstTotal(newEstTotal);
						child.parent = explore;
						frontier.add(child);
						frontierSet.add(child);
						System.out.println("\tupdating " + child.getCityName() + " : " + newTrueCost + " " + h(n) + " " + newEstTotal);
					}
				}else{
					Tree child = new Tree(explore, n);
					child.setTrueCost(newTrueCost);
					child.setEstTotal(newEstTotal);
					frontier.add(child);
					frontierSet.add(child);
					System.out.println("\tadded " + child.getCityName() + " : " + newTrueCost + " " + h(n) + " " + newEstTotal);
				}
			}
		}
		solution(explore, search);
	}

	public static void main(String [] args){
		Node[] n = new Node[20];

		String [] cities = {"Arad", "Bucharest", "Craiova", "Drobeta", "Eforie", "Fagaras", "Giurgiu", "Hirsova", "Iasi", "Lugoj", "Mehadia", "Neamt", "Oradea","Pitesti", "Rimnicu V.", "Sibiu","Timisoara", "Urziceni", "Vaslui", "Zerind"};

		for(int i = 0; i < 20; i++){
			n[i] = new Node(cities[i], i);
		}

		n[0].addEdge(n[15], 140);
		n[0].addEdge(n[16], 118);
		n[0].addEdge(n[19], 75);

		n[1].addEdge(n[13], 101);
		n[1].addEdge(n[17], 85);
		n[1].addEdge(n[5], 211);
		n[1].addEdge(n[6],90);

		n[2].addEdge(n[3],120);
		n[2].addEdge(n[14],146);
		n[2].addEdge(n[13],138);

		n[3].addEdge(n[10],75);

		n[4].addEdge(n[7],86);

		n[5].addEdge(n[15],99);

		n[7].addEdge(n[17],98);

		n[8].addEdge(n[11],87);
		n[8].addEdge(n[18],92);

		n[9].addEdge(n[10],70);
		n[9].addEdge(n[16],111);

		n[12].addEdge(n[19],71);
		n[12].addEdge(n[15],151);

		n[13].addEdge(n[14],97);

		n[14].addEdge(n[15],80);

		n[17].addEdge(n[18],142);

		aStar(n[9], n[1]);
	}
}