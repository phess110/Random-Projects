def maxCyclicPerm(s):
    B = []
    n = len(s)
    for i in range (0,n):
        B.append(0 if s[i] == 'a' else 1)
    A = B
    for i in range (0,n):
        A.append(A[i])
    r = list(reversed(B))
    P = sum(B)
    M = []
    M.append(sum(A[0:n]))
    for k in range (1,n):
        M.append(M[k-1] + A[n+k-1] - A[k-1])
    N = numpy.convolve(A,r)
    C = []
    for k in range (0,n):
        C.append(M[k] + P  - 2*N[n+k-1])
    return C

# j = argmax(C). Then the jth cyclic permutation of s maximizes the hamming distance. 

def longestIncrSubseq(A):
	l = len(A)
	if l == 0:
		return (0, A)
	idx = 0 # index of maximum element of L
	n = 0 # length of longest increasing subsequence
	L = [1] # L[i] =  length of longest increasing subsequence of A[0],...,A[i] ending in A[i]
	P = [-1] # P[i] = index j such that A[j] preceeds A[i] in the longest increasing subsequence of A[0],...,A[i] ending in A[i], -1 if no such index exists
	B = [] # longest increasing subsequence

	for i in range(1, l):
		m = 1
		p = -1
		for j in range(0,i):
			if(A[j] < A[i]):
				t = L[j] + 1
				if(t > m):
					m = t
					p = j
					idx = i
					n = m
		L.append(m)
		P.append(p)
	while(idx != -1):
		B.append(A[idx])
		idx = P[idx]
	B.reverse()
	return (n, B)
