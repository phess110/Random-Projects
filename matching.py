from sets import Set

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


X = Set([1,2,3,4])
Y = Set([5,6,7,8,9])


def symDiff(MapX, MapY, path):
	#aug path has odd length -> even no of vertices
	for i in range(0, len(path), 2): 
		MapX[path[i]] = path[i+1] #add edge x->y to M
		MapY[path[i+1]] = path[i] #add edge y->x to M (remove y's previous mapping)

def getAugmentingPath(G, MapX, MapY, X, Y):
	graph = matchingToGraph(G, MapX, MapY, X, Y)
	path = bfs(graph, -1, -2)
	if path == []:
		return []
	path.remove(-1)
	path.remove(-2)
	return path

#constructs digraph corresponding to matching. Any path P from s to t contains P-[s,t] = an M-augmenting path
def matchingToGraph(G, MapX, MapY, X, Y):
	UnSatX = [x for x in X if MapX[x] == 0]
	UnSatY = [y for y in Y if MapY[y] == 0]

	graph = { x : [y for y in g[x] if MapX[x] != y] for x in X} 		# if x is unmatched with y, add x -> y
	graph.update( {y : [x for x in g[y] if MapY[y] == x] for y in Y} ) 	# if y is matched with x, add y -> x
	graph.update( {-1 : UnSatX} )										# if x in X is unsaturated, add s -> x
	graph.update( {y : [-2] for y in UnSatY} ) 							# if y in Y unsaturated, add y -> t
	return graph

# Source -- https://stackoverflow.com/a/8922151
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
#

def printM(M, X):
	isEmpty = True
	st = "\\item $\\mathcal{M} = \\{"
	for x in X:
		if M[x] != 0:
			isEmpty = False
			st += "e_{" + str(x) + "," + str(M[x]) + "}, "
	if not isEmpty:
		st = st[:-2]
	st += "\\}$."
	print st

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
	MapX = {x : 0 for x in X} # M is a matching (mapping from X to Y). x |-> 0 indicates X is unmatched.
	MapY = {y : 0 for y in Y}
	print "\\begin{itemize}"
	printM(MapX, X)

	path = getAugmentingPath(G, MapX, MapY, X, Y)
	while(path != []):
		symDiff(MapX, MapY, path)
		printPath(path)
		path = getAugmentingPath(G, MapX, MapY, X, Y)
		printM(MapX, X)
	return (MapX, MapY)

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

def minVertexCover(G, X, Y, MapX, MapY):
	UnSatX = [x for x in X if MapX[x] == 0]
	graph = matchingToGraph(G, MapX, MapY, X, Y)
	S = Set()
	T = Set()
	for x in UnSatX:
		r = bfsReach(graph, x, X, Y)
		S = S.union(r[0])
		T = T.union(r[1])
	return T.union(X.difference(S))

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

def printCover(C):
	st = "\\item Minimum Vertex Cover: $Q = \\{"
	for v in C:
		st += str(v) + ", "
	st = st[:-2]
	st += "\\}$."
	print st

printCover(minVertexCover(g, X, Y, mx, my))
print "\\end{itemize}"