	public class Tree{
		Tree parent;
		private Node city;
		private int estTotal;
		private int trueCost;

		Tree(Tree p, Node s){
			parent = p;
			city = s;
			estTotal = 0;
			trueCost = 0;
		}

		/* Two tree are equal if they represent the same city */
		@Override
		public boolean equals(Object o){
			if(o instanceof Tree){
				Tree t = (Tree) o;
				return this.city == t.city;
			}
			return false;
		}

		void setTrueCost(int i){
			trueCost = i;
		}

		void setEstTotal(int i){
			estTotal = i;
		}

		int getEstTotal(){
			return estTotal;
		}

		int getTrueCost(){
			return trueCost;
		}

		Node getCity(){
			return city;
		}

		String getCityName(){
			return city.getName();
		}

		Tree getParent(){
			return parent;
		}
	}