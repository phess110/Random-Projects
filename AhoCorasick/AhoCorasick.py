'''
    Requires Python 3.8+
'''

# Imports
import queue

# Aho-Corasick trie node class
class TrieNode:
    __slots__ = ['child_dict', 'is_dict_node', 'dict_index', 'key', 'suffix', 'dict_suffix']

    def __init__(self, isDictNode, charKey, dictIndex = 0):
        self.child_dict = dict()
        self.is_dict_node = isDictNode
        if (isDictNode):
            self.dict_index = dictIndex
        self.key = charKey
        self.suffix = None
        self.dict_suffix = None

    def children(self):
        return self.child_dict.values()

    def __str__(self):
        return self.key

class Trie:
    __slots__ = ['_root', '_dictionary']
    
    def __init__(self):
        self._root = TrieNode(False, '\0')
        self._dictionary = []

    def insert(self, word):
        '''
            Standard method for inserting into a trie
        '''
        node = self._root
        word_len = len(word)
        for (idx, c) in enumerate(word):
            if c in node.child_dict:
                node = node.child_dict[c]
            else:
                if idx == word_len-1:
                    node.child_dict[c] = TrieNode(True, c, len(self._dictionary))
                    self._dictionary.append(word)
                else:
                    node.child_dict[c] = TrieNode(False, c)
                    node = node.child_dict[c]

    # Use BFS to print each level of the trie
    def print(self):
        q = queue.Queue()
        q.put(self._root)
        currLvlCnt = 1
        nextLvlCnt = 0
        while (not(q.empty())):
            node = q.get()
            currLvlCnt = currLvlCnt-1
            print(node, end='')
            for child in node.children():
                q.put(child)
                nextLvlCnt = nextLvlCnt + 1
            if (currLvlCnt == 0):
                currLvlCnt = nextLvlCnt
                nextLvlCnt = 0
                print()

    def add_suffix_links(self):
        '''
            Add the suffix links to the Aho-Corasick automaton

            Suffix link of a node connects to the longest suffix of that node
            that is also present in the tree.
        '''
        q = queue.Queue()
        for child in self._root.children():
            child.suffix = self._root
            q.put(child)

        while (not(q.empty())):
            parent = q.get()
            for child in parent.children():
                temp = parent.suffix
                while (child.key not in temp.child_dict and temp != self._root):
                    temp = temp.suffix
                child.suffix = temp.child_dict[child.key] \
                                    if child.key in temp.child_dict \
                                        else self._root
                q.put(child)

    def add_dict_suffix_links(self):
        '''
            Add the suffix links to the Aho-Corasick automaton

            Suffix link of a node connects to the longest suffix of that node
            that is also present in the tree.
        '''
        q = queue.Queue()
        q.put(self._root)
        while (not(q.empty())):
            node = q.get()
            # walrus operator
            if (suffix := node.suffix) is not None:
                node.dict_suffix = suffix if suffix.is_dict_node else suffix.dict_suffix
            for child in node.children():
                q.put(child)

    @classmethod
    def aho_corasick_trie(cls, dictionary):
        '''
            Builds an Aho-Corasick trie data structure/automaton.
        '''
        trie = Trie()
        for word in dictionary:
            trie.insert(word)

        trie.add_suffix_links()
        trie.add_dict_suffix_links()

        return trie
    
    def aho_corasick_follow_dict_links(self, node, location):
        '''
            If we match a given string, we also match all suffixes of that string
            so we need to follow the dict_suffix links to output all matches
        '''
        if node.is_dict_node:
            print(self._dictionary[node.dict_index], location)
        while (node.dict_suffix is not None):
            node = node.dict_suffix
            print(self._dictionary[node.dict_index], location)

    def aho_corasick_search(self, text):
        '''
            Perform a search for all occurrences of any word in the dictionary
            within the given text using the Aho-Corasick automaton.

            Prints the string matched followed by the index where the match ends
            within the search string (zero indexing).

            O(|text| + |dictionary| + |# matches|)
        '''
        state = self._root
        for (idx, c) in enumerate(text):
            while (c not in state.child_dict and state != self._root):
                state = state.suffix
            state = state.child_dict[c] if c in state.child_dict \
                                            else self._root
            self.aho_corasick_follow_dict_links(state, idx)

# Usage
AC_Tree = Trie.aho_corasick_trie(["aaa", "abab", "aaab", "baaab", "aaaba"])
AC_Tree.aho_corasick_search('aaababaaab')