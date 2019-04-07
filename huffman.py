
class node:
	def __init__(self):
		self.lchild = None
		self.rchild = None

	def addLchild(self, lc):
		self.lchild = lc

	def addRchild(self, rc):
		self.rchild = rc

class leaf: 
	def __init__(self, message):
		self.data = message
	
def huffmanEncode(P):
	P = sorted(P, reverse = True)
	T = []
	for val in P:
		T.append(leaf(val))
	if(len(P) == 1):
		return T[0]
	return huffmanHelper(P, T)

def huffmanHelper(P, T):
	n = len(P)
	if(n == 2):
		ht = node()
		ht.addLchild(T[0])
		ht.addRchild(T[1])
		return ht
	else:
		q = P[n - 1] + P[n - 2]
		mergeTree = node()
		mergeTree.addLchild(T[n-2])
		mergeTree.addRchild(T[n-1])
		T.pop()
		T.pop()
		P.pop()
		P.pop()
		idx = findInd(P,q)
		P.insert(idx, q)
		T.insert(idx, mergeTree)
		return huffmanHelper(P, T)

def findInd(P, q):
	for i in range(0, len(P)):
		if P[i] <= q:
			return i
	return len(P)


def printTree(T, s = ""):
	if isinstance(T.rchild, leaf) and isinstance(T.lchild, leaf):
		print(str(T.lchild.data) + ":" +  s + "0" + ", " + str(T.rchild.data) + ":" + s + "1")
	elif isinstance(T.rchild, leaf):
		printTree(T.lchild, (s + "0"))
		print(str(T.rchild.data) + ":" + s + "1")
	elif isinstance(T.lchild, leaf):
		print(str(T.lchild.data) + ":" + s + "0")
		printTree(T.lchild, (s + "1"))
	else:
		printTree(T.lchild, (s + "0"))
		printTree(T.rchild, (s + "1"))

printTree(huffmanEncode([5,1,1,7,8,2,3,6]))

