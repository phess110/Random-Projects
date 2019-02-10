class BinomialHeap
	attr_accessor :minNode, :start, :end
	$null = new Node(0,0)

	# this is a min-heap
	# consists of an array of binomial trees sorted in order of increasing rank
	def initialize
		@minNode = $null # in root list
		@roots = Array.new(10){$null}
		@minRank = Float::INFINITY
		@maxRank = -1 #maximum rank of a tree in the root list
		@size = 9 #size of root list. 
	end

	def doubleHeapSize
		l = @roots.length
		arr = Array.new(2*l) { $null }
		i = 0
		loop do
			arr[i] = @roots[i]
			i+=1
			break if i >= l
		end
		@roots = arr
		@size = 2*l - 1
		return true
	end

	# merge two binomial trees rooted at x and y, returns root of new tree
	def mergeTree(x,y)
		if (x > y) #exchange x and y
			t = y
			y = x
			x = t
		end
		#x <= y. Make y a child of x
		x.rank = x.rank + 1
		y.r = x.c
		y.l = x.c.l
		x.c.l = y
		x.c = y
		y.p = x
		x.r = y.r # y was to the right of x
		return x
	end

	# x and y are two binomial heaps
	def heapUnion(x,y)
		# TODO: add update for minRank, maxRank, minNode
		heap = new BinomialHeap()
		t1 = x.roots[0]
		t2 = y.roots[0]

		if(t1 == $null)
			if(x.hasNext(0))
				t1 = x.getNext(0)
			else
				return y
			end
		end

		if(t2 == $null)
			if(y.hasNext(0))
				t2 = y.getNext(0)
			else
				return x
			end
		end

		rankX = t1.rank
		rankY = t2.rank

		loop do
			if(rankX > rankY)
				t = t2
				t2 = t1
				t1 = t
				rankY = rankX
				rankX = t.r
			end
			#now rankX <= rankY
			if(rankX < rankY)
				heap.addTree(t1)
				if( x.hasNext(t1) )
					t1 = x.getNext(t2)
				else
					# TODO add rest of y to heap then return
				end
			else
				#rank of both are equal
				heap.add(mergeTree(t1,t2)) #rank of both are equal, merge t1 and t2 then add to heap

				if( x.hasNext(t1) )
					t1 = x.getNext(t1)
				else
					# TODO add rest of y to heap and return
				end
				if ( y.hasNext(t2) )
					t2 = y.getNext(t2)
				else
					# TODO add rest of x to heap and return
				end
			end
		end
	end

	def hasPrev(root)
		return root.rank > @minRank
	end

	def hasNext(root)
		return root.rank < @maxRank
	end

	# returns previous non-null tree in heap, $null otherwise
	def getPrev(root)
		if(not hasPrev(root))
			return $null
		end
		i = root.rank
		while(i > @minRank)
			i+=1
			if(@roots[i]  != $null)
				return @roots[i]
			end
		end
		return @roots[i]
	end

	# returns next non-null tree in heap, $null otherwise
	def getNext(root)
		if(not hasNext(root))
			return $null
		end
		i = root.rank
		while(i < @maxRank)
			i+=1
			if(@roots[i] != $null)
				return @roots[i]
			end
		end
		return @roots[i]
	end

	# add tree x to binomial heap
	def addTree(x){
		heap = self
		if(x.rank > heap.size)
			heap.doubleHeapSize
			heap.addTree(x)

		elsif(heap.roots[x.rank] == $null)
			#update minRank and maxRank
			if(x.rank < @minRank)
				@minRank = x.rank
			end
			if(x.rank > @maxRank)
				@maxRank = x.rank
			end
			#update minNode
			if(x < @minNode)
				@minNode = x
			end

			heap.roots[x.rank] = x
			x.l = heap.getPrev(x)
			x.r = heap.getNext(x)
		else
			y = mergeTree(heap.roots[x.rank], x)
			heap.addTree(y)
		end
	}

	# insert value x with key k into binomial heap
	def insert(x, k)
		t = new Node(x,k)
		t.r, t.l, t.p, t.c = $null, $null, $null, $null
		if empty? 
			@minNode = t
			@maxRank = 0
			@minRank = 0
			@roots[0] = t
		else
			if(t < @minNode) #maintain minNode
				@minNode = t
			end
			self.addTree(t)
		end
		return t
	end

	# Here x is a node (not a value or key) and k is the new key.
	# k must be less than the current key of x. 
	# Note: every insertion returns the node which was inserted. We can then add the inserted node into a hash table.
	# to decrease the key we hash the key/value to find the node and update.
	def decreaseKey(x,k)
		# TODO: add update for minNode, maxRank, minRank
		if(k < x.key)
			x.key = k
			bubbleUp(x)
		end
	end

	def bubbleUp(x)
		# TODO: add update for minNode, maxRank, minRank
		while(x.p != $null)
			if(x < x.p) #swap x and its parent 
				t = x.l
				x.l = (x.p).l
				(x.p).l = t

				t = x.r
				x.r = (x.p).r
				(x.p).r = t

				t = x.c
				x.c = x.p
				(x.p).c = t

				t = x.p
				x.p = (x.p).p
				(x.p).p = x
			else
				break
			end 
			x = x.p
		end
	end
	
	# returns value of minimum node in the binomial heap. Does not remove it.
	def getMin
		return @minNode.val
	end

	# returns and removes the minimum node in the binomial heap. Maintains heap properties.
	def deleteMin
		# TODO: add update for minNode, maxRank, minRank
		x = getMin
		child = x.c
		while(child != $null) #for each child of x, add it to the heap
			addTree(child)
			child = child.r
		end
		return x.val
	end

	def empty?
		@minNode == $null
	end
end


class Node
	attr_accessor :val, :key, :p, :c, :r, :l, :rank
	def initialize(v, k)
		@val = v
		@key = k 
		@p = nil #parent
		@c = nil #child
		@r = nil #right
		@l = nil #left
		@rank = 0
	end

	#node comparator
	def <(other)
		@key < other.key
	end
end
