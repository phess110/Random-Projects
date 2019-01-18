require_relative 'BinaryHeap'
require_relative 'Node'

class Vertex
	attr_accessor :i, :neighbors, :weights, :key

	def initialize(index)
		@i = index
		@neighbors = []
		@weights = []
	end

	def <(other)
		@key < other.key
	end
end

class Graph
	attr_accessor :vertices, :size, :is_directed

	def initialize(args) # up to 3 args
		@vertices = []
		@size = 0
		(args[:size].nil? ? 0 : args[:size]).times {self.add_vertex}
		@is_weighted = args[:weight].nil? ? false : args[:weight] #default false
		@is_directed = args[:dir].nil? ? true : args[:dir] #default true
	end

	def w(u,v) #first param is vertex, second param is index (int) of a vertex
		u.weights[u.neighbors.index(v)]
	end

	def to_s
		puts "Size: #{@size}\n"
		@vertices.each do |v|
			puts "#{v.i} neighbors: #{v.neighbors}\n"
		end
		puts "Is weighted: #{@is_weighted}\n"
		puts "Is directed: #{@is_directed}\n"
	end

	def [](ind) #index to vertex, e.g. g[1]
		self.vertices[ind]
	end

	def is_empty
		@size == 0
	end

	def add_vertex
    	@vertices << Vertex.new(@size)
    	@size += 1
	end

	def add_edge(u, v, weight = nil) #pass vertices, not indices
    	u.neighbors << v.i
    	if (not @is_weighted) and weight
    		warn("Warning: edge weight was passed for unweighted graph")
    	end
    	u.weights << weight if weight
    	if not @is_directed
      		v.neighbors << u.i
      		v.weights << weight if weight
    	end
  	end

  	def max (a,b)
  		a > b ? a : b
	end

	def min (a,b)
  		a > b ? b : a
	end

  	#def set_weight(u,v)

  	# @return: visited[u] = true <=> u is reachable from v, O(V+E)
	def explore(v, visited)
		visited[v.i] = true
		v.neighbors.each do |u|
			if not visited[u]
				explore(self[u], visited)
			end
		end
		visited
	end

	# true <=> graph is connected, O(V+E)
	def isConnected
		return isConnectedUndir if not @is_directed 
		isConnectedDir
	end

	# returns the reverse/transpose graph, O(V+E)
	def reverse
		return self if not @is_directed
		revVertices = []
		@vertices.each do |v|
			revVertices << Vertex.new(v.i) #???
		end
		@vertices.each do |v|
			v.neighbors.each do |u|
				revVertices[u].neighbors << v.i
				revVertices[u].weight << v.weight if @is_weighted
			end
		end
		gr = Graph.new(weight: @is_weighted, dir: @is_directed)
		gr.size = @size
		gr.vertices = revVertices
		gr
	end

	def isConnectedUndir
		return true if is_empty 
		explore(self[0], Array.new(@size){false}).all? {|i| i}
	end

	def isConnectedDir
		(isConnectedUndir and reverse.isConnectedUndir)
	end

	def DFS # O(V+E)
		c = Counter.new
		post = Array.new(@size)
		visited = Array.new(@size) {false}

		@vertices.each do |v|
			if not visited[v.i]
				post = DFSexplore(v, visited, post, c)
			end
		end

		post
	end

	def DFSexplore(v, visited, post, c) # O(V+E)
		visited[v.i] = true
		v.neighbors.each do |u|
			if not visited[u]
				DFSexplore(self[u], visited, post, c)
			end
		end
		post[v.i] = c.c
		c << 1
		return post
	end

	def topologicalSort #given a dag, returns a topological sort of its vertices (by index)
		post = self.DFS
		sort = Array.new(@size)
		for i in 0..(@size - 1) do
			sort[@size - post[i] - 1] = i
		end
		print sort
	end

	def hasCycle?
		#Directed: compute SCCs. If some SCC has more than one vertex -> cycle.
		#Undirected (detect 3-cycles): use BFS (what does it mean if an already visited vertex is encountered)
	end

	def sinkVertex
		@vertices[self.DFS.min] #should be argmin not min
	end

	def sourceVertex
		@vertices[self.DFS.max] #^^ argmax
	end

	def SCCs
		post = (self.reverse).DFS
	end

	def bipartiteMatching
		#use flows
	end

	def BFS #untested
		parent = Array.new(@size)
		visited = Array.new(@size) {false}
		queue = Queue.new
		@vertices.each do |v|
			if not visited[v.i]
				post = BFSexplore(v, visited, parent, queue)
			end
		end
		parent
	end

	def BFSexplore(v, visited, parent, queue) #untested
		visited[v.i] = true
		v.neighbors.each do |u|
			if( not visited[u.i] )
				visited[u.i] = true
				parent[u.i] = v
				queue.push(u)
			end
		end
		if(not queue.empty?)
			BFSexplore(queue.pop, visited, parent, queue)
		end
	end

	def isBipartite?
		#use BFS, alternatively assign vertices colors of red and blue 
		#if a red vertex gets colored blue, or vice versa -> no; if terminates -> yes
	end

	#all-pairs shortest path O(|V|^3)
	def FloydWarshall 
		d = Array.new(@size){Array.new(@size){Float::INFINITY}}
		for i in 0..(@size-1)
			d[i][i] = 0
		end

		@vertices.each do |v|
			v.neighbors.each do |u|
				d[v.i][u] = w(v,u)
			end
		end

		for k in 0..(@size-1)
			for i in 0..(@size-1)
				for j in 0..(@size-1)
					d[i][j] = min(d[i][j] , d[i][k] + d[k][j])
				end
			end
		end
		return d
	end

	#requires non-negative edges weights
	def Dijkstra(s) 
		d = BinaryHeap.new(@size) 
		distance = Array.new(@size)
		marked = Array.new(@size) {false}
		nodes = Array.new(@size)

		@vertices.each do |v| # O(Vlog V)
			k = (v == s) ? 0 : Float::INFINITY #initialize heap
			n = Node.new(v,k)
			nodes[v.i] = n
			d.insert(n)
		end

		while (not d.empty?)
			m = d.deleteMin
			k = m.key
			m = m.val
			distance[m.i] = k 
			marked[m.i] = true
			m.neighbors.each do |u|
				if(not marked[u])
					tmp = distance[m.i] + w(m,u)
					if(nodes[u].key > tmp)
						d.updateKey(nodes[u], tmp)
					end
				end
			end
		end
		return distance
	end

	#johnson's algorithm?
	#prim's algorithm?

	def Prims
		heap = BinaryHeap.new
		e = 0
		marked = Array.new(@size){Array.new(@size) {false}}
		#s = Set.new() #set of edges which constitute a mwst

		@vertices.each do |v|
			#initialize heap...
			if(marked[v.i] == false)
				marked[v.i] = true
					n = Node.new([], )
					heap.insert(n)
			end
		end

		while (c < @size and not heap.empty?)
			m = d.deleteMin
		end

		if (c < @size)
			fail "Graph is not connected"
		end
		return s
	end

	def BellmanFord(s) #single-source shortest path, O(VE) 
		d = Array.new(@size) {Float::INFINITY}
		d[s.i] = 0
		j = 1
		while(j < @size) # O(V)
			@vertices.each do |v| # O(E)
				v.neighbors.each do |u|
					d[u] = min(d[u], d[v.i] + w(v,u))
					#could add precessor array to build path
				end
			end
			j += 1
		end

		#could test for negative cycles 
		return d
	end

	# Given a directed graph with capacity function c: V * V -> R_{>=0} 
	# (assumes every vertex is reachable from s & no cycles of length 1 or 2),
	# with a distinguish source, s, and sink, t, return max flow
	# Floyd-Fulkerson using shortest augmenting path [Edmond-Karp], O(VE^2)
	def maxFlow(c,s,t) 
		f = Array.new(@size){Array.new (@size)} #flow function f: V * V -> R
		gf = residualNetwork(f, c)
		p = pathFinderBFS(gf, s, t)
		if p != nil # no. iterations <= VE/2
			f = augmentFlow(f, p) # O(V)
			gf = residualNetwork(f, c)
			p = pathFinderBFS(gf, gf[s.i], gf[t.i]) # O(V + E)
		end
		return f
	end 


	def augmentFlow(f,p) #add residual capacity of path p to flow f, O(V)
		r = residualCapacity(f,p)
		p.vertices.each do |v| 
			if(v.neighbors.size > 0)
				if(self[v.i].neighbors.include?(self[v.neighbors[0]])) #is (v,u) in G?
					f[v.i][v.neighbors[0].i] += r
					f[v.neighbors[0].i][v.i] -= r
				else
					f[v.i][v.neighbors[0].i] -= r
					f[v.neighbors[0].i][v.i] += r
				end
			end
		end
	end

	def residualCapacity(f,p) #minimum capacity along augmenting path, O(V)
		m = v.weights[0]
		p.vertices.each do |v|
			if(not v.weights.empty?)
				m = min(m, v.weights[0])
			end	
		end
		return m
	end

	def pathFinderBFS(gf,s,t) #returns a (weighted, directed) path graph from s to t in gf, O(V+E)
		parent = gf.BFSexplore(s, Array.new(@size), Array.new(@size), Queue.new) # O(V+E)
		if (parent[t.i] == nil)
			return nil #no augmenting path
		end
		path = Graph.new(weight: true, dir: true)
		n = Vertex.new
		n.i = t.i
		path.vertices << n
		v = t
		u = t
		while (u != s) # O(V)
			v = parent[u.i]
			n = Vertex.new
			n.i = v.i
			n.neighbors = [u]
			n.weights = [w(v,u)]
			path.vertices << n
			u = v
		end
		return path
	end

	def residualNetwork(f,c) #compute the residual network given a flow, O(V+E)
		gf = Graph.new(weight: true, dir: true) # O(1)

		@vertices.each do |v| # O(V)
			gf.add_vertex
		end

		@vertices.each do |v| # O(E)
			v.neighbors.each do |u|
				if f[v.i][u.i] >= 0
					w = c[v.i][u.i] - f[v.i][u.i]
					w_rev = f[v.i][u.i] #assuming f(u,v) >= 0
					if(w != 0)
						gf.add_edge(gf[v.i], gf[u.i], w)
					end
					if(w_rev != 0)
						gf.add_edge(gf[u.i], gf[v.i], w_rev)
					end
				end
			end
		end
	end

end

class Counter
	attr_accessor :c
	def initialize
		@c = 0
	end

	def <<(k)
		@c += k
	end
end

#returns C_n (directed/undirected)
def cycleGraph(n, is_dir = false, is_weighted = false) 
	g = Graph.new(size: n, dir: is_dir, weight: is_weighted)
	for i in 0..(n-1) do
		g.add_edge(g[i], g[(i+1) % n]) #weight?
	end
	return g
end

#returns undirected K_n
def completeGraph(n, is_weighted = false) 
	g = Graph.new(size: n, dir: false, weight: is_weighted)
	for i in 0..(n-1) do
		for j in 0..(n-1) do
			if(j != i)
				g.add_edge(g[i],g[j])
			end
		end
	end
	return g
end

#returns P_n (directed or undirected)
def pathGraph(n, is_dir = false, is_weighted = false) 
	g = Graph.new(size: n, dir: is_dir, weight: is_weighted)
	for i in 0..(n-2) do
		g.add_edge(g[i],g[i+1])
	end
	return g
end

=begin

g = Graph.new(size: 3)
g.add_edge(g[0],g[1])
g.add_edge(g[1],g[2])

g = Graph.new(size: 6, weight: true)
g.add_edge(g[0],g[1],1)
g.add_edge(g[1],g[2],5)
g.add_edge(g[0],g[3],1)
g.add_edge(g[3],g[2],1)
g.add_edge(g[4],g[3],2)
g.add_edge(g[4],g[1],6)
g.add_edge(g[2],g[4],3)
g.add_edge(g[2],g[5],3)
g.add_edge(g[4],g[5],1)

tree
g = Graph.new(size: 7)
g.add_edge(g[0],g[1])
g.add_edge(g[0],g[2])
g.add_edge(g[1],g[3])
g.add_edge(g[1],g[4])
g.add_edge(g[2],g[5])
g.add_edge(g[2],g[6])
=end