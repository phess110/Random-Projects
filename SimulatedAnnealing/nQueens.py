import random, itertools,copy
from math import exp
# simulated annealing algorithm for the n-queens problem
n = 8

# a state gives is an array a[] of length n. a[i] specifies the column number of the queen in row i. 
def randomState():
 	s = []
 	for i in range(0, n):
 		s.append(random.randint(0,n-1))
 	return s

# generates a random move (i,j). Queen in row i goes to column j.
def randomMove():
	return (random.randint(0,n-1), random.randint(0,n-1))

def applyMove(s,a):
	t = copy.copy(s)
	t[a[0]] = a[1]
	return t

def printState(s):
 	for i in range(0, n):
 		print "|",
 		for j in range(0, 	n):
 			if(s[i] == j):
 				print "Q",
 			else:
 				print "_",
 		print "|\n",

# Number of queens underattack in state s. Will double count if some queen is attacked by multiple others. 
def numberAttacking(s):
	k = 0
	for i in range(0, n):
		j = s[i]
		rUP = range(i-1,-1,-1)
		rDOWN = range(i+1,n)
		cLEFT = range(j-1,-1,-1)
		cRIGHT = range(j+1,n)
		k += attackVert(s, i, j, rUP) #up
		k += attackVert(s, i, j, rDOWN) #down
		k += attackDiag(s, i, j, rUP, cLEFT) #NW
		k += attackDiag(s, i, j, rDOWN, cLEFT) #SW
		k += attackDiag(s, i, j, rUP, cRIGHT) #NE
		k += attackDiag(s, i, j, rDOWN, cRIGHT) #SE
		# don't need to check within the row
	return k

def attackVert(s, i, j, range1):
	k = 0
	for r in range1:
		if(s[r] == j):
			k += 1
	return k

def attackDiag(s, i, j, range1, range2):
	k = 0
	for r,c in itertools.izip(range1, range2):
			if(s[r] == c):
				k += 1
	return k

# probability of selecting a "bad" move
def prob(deltaE, t):
	return exp(deltaE/schedule(t))

def schedule(t):
	c = 1.0 # vary this
	return 1/(c* t) 

def simulatedAnnealing():
	s = randomState()
	t = 1
	k = numberAttacking(s)
	while(k > 0 and t <= 5000): # vary number of moves allowed
		newState = applyMove(s,randomMove())
		kTemp = numberAttacking(newState)
		if(kTemp <= k):
			s = newState
			k = kTemp
		elif(random.random() < prob(k - kTemp, t)):
			s = newState
		t += 1
	if(k != 0): #failure
		return -1
	else: #success
		#printState(s)
		#print t
		#print "\n"
		return t

def main():
	numSuccesses = 0
	numFailures = 0
	numTrials = 100 # vary this
	while(numTrials > 0):
		if(simulatedAnnealing() == -1):
			numFailures += 1
		else:
			numSuccesses += 1
		numTrials -= 1
	print numSuccesses
	print numSuccesses/float(numSuccesses + numFailures)

main()