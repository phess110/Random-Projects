import java.util.Comparator;

public class MyComparator implements Comparator<Node> {
    public int compare(Node a, Node b) {
        return a.eval - b.eval;
    }
}