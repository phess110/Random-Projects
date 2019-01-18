class BinomialHeap
	attr_accessor 

	def initialize
		@minNode = nil
		@start = nil
		@end = nil
		@null = new Node(0,0)
	end

	def merge(x,y)
		if (x > y) #exchange x and y
			t = y
			y = x
			x = t
		end
		#x <= y
		x.rank = x.rank + 1
		y.r = x.c
		y.l = x.c.l
		x.c.l = y
		x.c = y
		y.p = x
		x.r = y.r
		return x
	end

	def insert(x, k)
		t = new Node(x,k)
		if @minNode == nil
			t.r, t.l, @start, @end, @minNode = t, t, t, t, t
			t.p, t.c = @null
		else
			if(t < @minNode)
				@minNode = t
			end
			t.l = @end
			t.r = @start
			@end.r = t
			@start.l = t
			t.c = @null
			t.p = @null
			while t.r.rank = t.rank
				t = merge(t, t.r)
			end
		end
	end

	def findRank(t)
		y = t.r
		while y != t
			if y.rank = t.rank
				return y
			end
			y = y.r
		end
		return nil
	end

	def decreaseKey(x,k)

	end

	def deleteMin

	end

	def empty?
		@minNode == nil
	end


end


class Node
	attr_accessor :val, :key, :p, :c, :r, :l, :rank
	def initialize(v, k)
		@val = v
		@key = k
		@p = nil
		@c = nil
		@r = nil
		@l = nil
		@rank = 0
	end

	def <(other)
		@key < other.key
	end
end