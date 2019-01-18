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