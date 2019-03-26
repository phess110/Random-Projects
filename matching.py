from sets import Set

# SAMPLE INPUTS

# Partite Sets
X = Set([1,2,3,4])
Y = Set([5,6,7,8,9])

# Graph represent is adj. list form (mapping from vertices to list of neighbors)
g = {
	1 : [7],
	2 : [7,9],
	3 : [5,6,7,9],
	4 : [6,7,8,9],
	5 : [3],
	6 : [3,4],
	7 : [1,2,3,4],
	8 : [4],
	9 : [3,4]
}

'''g = {
	1 : [5,6,7,8,9],
	2 : [6,7,8,9],
	3 : [5,6],
	4 : [6],
	5 : [1,3],
	6 : [1,2,3,4],
	7 : [1,2],
	8 : [1,2],
	9 : [1,2]
}'''

# Augment matchings via the augmenting path
def symDiff(MapX, MapY, path):
	#aug path has odd length -> even no of vertices
	for i in range(0, len(path), 2): 
		MapX[path[i]] = path[i+1] #add edge x->y to M
		MapY[path[i+1]] = path[i] #add edge y->x to M (remove y's previous mapping)

# Returns an M-augmenting path in G (or [] if none exists)
def getAugmentingPath(G, MapX, MapY, X, Y):
	graph = matchingToGraph(G, MapX, MapY, X, Y)
	path = bfs(graph, -1, -2)
	if path == []:
		return []
	path.remove(-1)
	path.remove(-2)
	return path

# Constructs digraph corresponding to matching. Any path P from s to t contains P-[s,t] = an M-augmenting path
def matchingToGraph(G, MapX, MapY, X, Y):
	UnSatX = [x for x in X if MapX[x] == None]
	UnSatY = [y for y in Y if MapY[y] == None]

	graph = { x : [y for y in G[x] if MapX[x] != y] for x in X} 		# if x is unmatched with y, add x -> y
	graph.update( {y : [x for x in G[y] if MapY[y] == x] for y in Y} ) 	# if y is matched with x, add y -> x
	graph.update( {-1 : UnSatX} )										# if x in X is unsaturated, add s -> x
	graph.update( {y : [-2] for y in UnSatY} ) 							# if y in Y unsaturated, add y -> t
	return graph

# Source -- https://stackoverflow.com/a/8922151
# Finds shortest start,end-path
def bfs(graph, start, end):
    # maintain a queue of paths
    queue = []
    # push the first path into the queue
    queue.append([start])
    while queue:
        # get the first path from the queue
        path = queue.pop(0)
        # get the last node from the path
        node = path[-1]
        # path found
        if node == end:
            return path
        # enumerate all adjacent nodes, construct a new path and push it into the queue
        for adjacent in graph.get(node, []):
            new_path = list(path)
            new_path.append(adjacent)
            queue.append(new_path)
    return []

# Prints a matching M on a graph with partite set X (LaTeX)
def printM(M, X):
	isEmpty = True
	st = "\\item $\\mathcal{M} = \\{"
	for x in X:
		if M[x] != None:
			isEmpty = False
			st += "e_{" + str(x) + "," + str(M[x]) + "}, "
	if not isEmpty:
		st = st[:-2]
	st += "\\}$."
	print st

# Prints a path (list of vertices) (LaTeX)
def printPath(p):
	if p == []:
		print "No augmenting paths. $\\mathcal{M}$ is maximum."
		return
	st = "\\begin{itemize}\\item Found path: $"
	for i in range(0,len(p)-1):
		st += "e_{" + str(p[i]) + "," + str(p[i+1]) + "}, "
	st = st[:-2]
	st += "$\\end{itemize}"
	print st

def maxMatching(G, X, Y): #undirected bipartite graph G as specified in an adjacency lists (dict), X and Y are partite sets of G, vertices are ints: 1,2,3,...
	MapX = {x : None for x in X} # M is a matching (mapping from X to Y). x |-> 0 indicates X is unmatched.
	MapY = {y : None for y in Y}
	#print "\\begin{itemize}"
	#printM(MapX, X)

	path = getAugmentingPath(G, MapX, MapY, X, Y)

	while(path != []):
		symDiff(MapX, MapY, path)
		#printPath(path)
		path = getAugmentingPath(G, MapX, MapY, X, Y)
		#printM(MapX, X)
	return (MapX, MapY)

# Breadth first search: computes S (T) the sets of vertices in X (Y) reachable in the graph from s
def bfsReach(graph, s, X, Y):
    S = Set([s])
    T = Set()
    queue = []
    queue.append(s)
    marked = [False for x in X]
    for y in Y:
    	marked.append(False)
    marked.append(False)

    while len(queue) > 0:
        node = queue.pop(0)

        for adjacent in graph.get(node, []):
        	if adjacent in X:
        		S.add(adjacent)
        	elif adjacent in Y:
        		T.add(adjacent)
        	if adjacent != -2 and marked[adjacent] == False:
        		marked[adjacent] = True
            	queue.append(adjacent)
    return (S,T)

# S = set of vertices in X reachable by M-alternating paths (starting an an unsaturated X-vertex)
# T = set of vertices in Y reachable by M-alternating paths (starting an an unsaturated X-vertex)
def computeSandT(G, X, Y, MapX, MapY):
	UnSatX = [x for x in X if MapX[x] == None]
	graph = matchingToGraph(G, MapX, MapY, X, Y)
	S = Set()
	T = Set()
	for x in UnSatX:
		r = bfsReach(graph, x, X, Y)
		S = S.union(r[0])
		T = T.union(r[1])
	return (S,T)

def minVertexCover(G, X, Y, MapX, MapY):
	(T,S) = computeSandT(G, X, Y, MapX, MapY)
	return T.union(X.difference(S))

# prints (unweighted) vertex cover (LaTeX)
def printCover(C):
	st = "\\item Minimum Vertex Cover: $Q = \\{"
	for v in C:
		st += str(v) + ", "
	st = st[:-2]
	st += "\\}$."
	print st

# Test if matching Map is a perfect matching in K_{n,n}.
# X is one of the partite sets
def isPerfect(Map, X):
	for x in X:
		if Map[x] == None:
			return False
	return True

# compute G_{u,v}
def getExcessGraph(W,u,v):
	n = len(W)
	g = { i : [] for i in range(0,n)}
	g.update([(j, []) for j in range(n,2*n)])

	for i in range(0, n):
		for j in range(n,2*n):
			if(u[i] + v[j%n] - W[i][j%n] == 0):
				# add edge i,j of excess 0 to g
				g[i].append(j)
				g[j].append(i)
	#print g
	return g

# weighted matching
# input : n x n weight matrix W of K_{n,n}. Weights must be in range: 0 - 2^20
def weightedMatching(W):
	# initialize cover
	n = len(W)
	u = [max(row) for row in W] 
	v = [0]*n
	X = Set(list(range(0,n)))
	Y = Set(list(range(n,2*n)))
	mx = {}
	my = {}

	while (True):
		excessGraph = getExcessGraph(W,u,v)
		(mx, my) = maxMatching(excessGraph, X, Y)

		if(isPerfect(mx, X)):
			break
		(S,T) = computeSandT(excessGraph, X, Y, mx, my)

		# find min excess of S to Y-T vertices
		R = Y.difference(T)
		eMin = 1048576 # 2**20
		for s in S:
			for r in R:
				eMin = min(eMin, u[s] + v[r%n] - W[s][r%n])
		for s in S:
			u[s] -= eMin
		for t in T:
			v[t%n] += eMin
	return (mx, u, v)

##
## TEST PROGRAM HERE
##

# Run/display maximum matching
'''
(mx, my) = maxMatching(g,X,Y)

isEmpty = True
st = "\\item Maximum Matching: $\\mathcal{M} = \\{"
for x in X:
	if mx[x] != 0:
		isEmpty = False
		st += "e_{" + str(x) + "," + str(mx[x]) + "}, "
if not isEmpty:
	st = st[:-2]
st += "\\}$."
print st

# Run minVertexCover
printCover(minVertexCover(g, X, Y, mx, my))
print "\\end{itemize}"
'''

# Sample weight matrix for K_{5,5}
W = [[4,1,6,2,3],[5,0,3,7,6],[2,3,4,5,8],[3,4,6,3,4],[4,6,5,8,6]]
n = len(W)
(mapX, u, v) = weightedMatching(W)

print "X vertex weights : " + str(u)
print "Y vertex weights : " + str(v)
print "Vertex cover cost : " + str(sum(u) + sum(v))
print "Maximum Weight Matching : " + str(mapX)
weight = 0
for x in range(0,n):
	weight += W[x][(mapX[x])%n]
print "Matching weight: " + str(weight)