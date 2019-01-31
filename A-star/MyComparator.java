import java.util.Comparator;

public class MyComparator implements Comparator<Tree> {
    public int compare(Tree a, Tree b) {
        return a.getEstTotal() - b.getEstTotal();
    }
}