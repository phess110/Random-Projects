def longest_increasing_subsequence(A):
    '''
        Returns a pair (n, B) where B is
        the longest increasing subsequence of list A
        and n is the length of B
    '''
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