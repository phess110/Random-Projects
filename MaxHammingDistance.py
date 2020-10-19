import numpy

def hamming_dist_cyclic_perm(s):
    '''
        The input string s should contain only 'a's and 'b's.

        Given a string s, a cyclic permutations of s is formed 
        by repeatedly moving the last character of s to the front 
        of s. For example, the cyclic permutations of "abba" are:
            abba, aabb, baab, bbaa
        
        We return the Hamming distance between
        each cyclic permutation and the original string s.
    '''

    # Convert A to list of 0s and 1s
    n = len(s)
    A = [0 if c == s[0] else 1 for c in s]
    b_count = sum(A)
    r = list(reversed(A))

    '''
        The Hamming distance of two strings
        a_0...a_n and b_0...b_n of 0s and 1s
        is given by:
            sum(a_i(1-b_i) + b_i(1-a_i)).

        In our case, a = s and b would be a cyclic permutation of 
        s, so the sum reduces to 

        2 * b_count - dot_product(s, jth_cyclic_perm(s))
    '''

    # All cyclic permutations of A are contained in 
    # A appended to itself
    A.extend(A)

    # use a convolution to efficiently compute the dot product
    N = numpy.convolve(A, r)

    return [2*(b_count - N[n+k-1]) for k in range(n)]

# If j = argmax(C), then the j-th cyclic permutation of s maximizes the Hamming distance. 