import java.util.HashSet;
import java.util.Iterator;

public class MySet<Tree>{
	private HashSet<Tree> set;

	MySet(){
		set = new HashSet<Tree>();
	}

	public boolean add(Tree t){
		return set.add(t);
	}

	public boolean contains(Object o){
		return set.contains(o);
	}

	public boolean isEmpty(){
		return set.isEmpty();
	}

	Tree remove(Node o){
		Iterator<Tree> iterator = set.iterator();
		while(iterator.hasNext()){
			Tree t = iterator.next();
			if(t.equals(o)){
				return t;
			}
		}
		return null;
	}
}