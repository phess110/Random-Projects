
pattern = ""

def KMP_table(W):
    '''
        Build the KMP table for word W.

        O(|W|)
    '''
    global pattern, table
    pattern = W
    table = [-1]
    pos = 1 # current position we are computing in T
    cnd = 0 # zero-based index in W of the next character of the current candidate substring

    while pos < len(W):
        if W[pos] == W[cnd]:
            table.append(table[cnd])
        else:
            table.append(cnd)
            cnd = table[pos]
            while cnd >= 0 and W[pos] != W[cnd]:
                cnd = table[cnd]
        pos = pos + 1
        cnd = cnd + 1
    table.append(cnd)

def KMP_search(S):
    '''
        Search string S for all occurrences of pattern.
        
        O(|S|)
    '''
    P = []
    j = 0
    k = 0
    while j < len(S):
        if pattern[k] == S[j]:
            j = j+1
            k = k+1
            if k == len(pattern):
                P.append(j-k)
                k = table[k]
        else:
            k = table[k]
            if k < 0:
                j = j+1
                k = k+1
    return P

KMP_table("ABCDABD")
P = KMP_search("ABA ABCDAB ABCDABCDABDE")
print(P)