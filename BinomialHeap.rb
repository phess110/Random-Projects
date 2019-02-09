class BinomialHeap
	attr_accessor :minNode, :start, :end
	$null = new Node(0,0)

	# consists of a circularly linked root list of binomial trees sorted in order of increasing rank
	def initialize
		@minNode = $null # in root list
		@start = $null #of root list
		@end = $null #of root list
	end

	def merge(x,y)
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

	# insert value x with key k into binomial heap
	def insert(x, k)
		t = new Node(x,k)
		if empty? 
			t.r, t.l, @start, @end, @minNode = t, t, t, t, t
			t.p, t.c = $null
		else
			if(t < @minNode) #maintain minNode
				@minNode = t
			end
			#insert t at front
			t.l = @end 
			t.r = @start
			@end.r = t
			@start.l = t
			t.c = $null
			t.p = $null
			#merge until the rank of every tree in root list is distinct
			while t.r.rank = t.rank
				t = merge(t, t.r)
			end
		end
	end

	#returns the root of a tree with same rank as t
	def findRank(t) 
		y = t.r
		while y != t
			if y.rank = t.rank
				return y
			end
			y = y.r
		end
		return $null #search failed
	end

	#decreases node x to key k. Note k must be less than the current key of x
	def decreaseKey(x,k)
	
	end
	
	#returns minimum node in the binomial heap. Does not remove it.
	def getMin
		return @minNode
	end

	#returns and removes the minimum node in the binomial heap. Maintains heap properties.
	def deleteMin

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
