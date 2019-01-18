require_relative 'Node'

class BinaryHeap #currently minheap
	attr_accessor :arr, :size, :contents
	
	def initialize(s = 10)
		@arr = Array.new(s+1)
		@size = s
		@contents = 0
	end

	def empty?
		return @contents == 0
	end

	def insert(n) #insert a node into heap (key must be set already), O(lg n)
		if (@contents == @size)
			temp = Array.new(2 * @size)
			for i in 0..(@size - 1) do
				temp[i] = @arr[i]
			end
			@size = 2 * @size
			@arr = temp
		end
		@arr[@contents] = n
		n.pos = bubble_up(@contents)
		@contents += 1
	end

	#findn node v in heap (starting search at i), O(n)
	def find(v, i) 
		if(@arr[i] == v)
			return i
		elsif(i > @contents)
			fail "value not found"
		elsif(@arr[i] < v) #flip for maxheap
			findVal(v,lchild(i)) 
			findVal(v,rchild(i))
		end
	end

	#updates key of vertex, adjusts v's position in heap, O(lg n)
	def updateKey(n, new_key)
		if(new_key < n.key)
			n.key = new_key
			n.pos = bubble_up(n.pos) #swap to bubble_down for maxheap
		else
			n.key = new_key
			n.pos = bubble_down(n.pos)
		end
	end

	#move object at position i up after insertion or key decrease, O(lg n)
	def bubble_up(i)
		while(i != 0)
			par = parent(i)
			if (@arr[i] < @arr[par]) #currently minheap, change to > for maxheap
				tmp = @arr[par]
				@arr[par] = @arr[i] #swap child and parent
				tmp.pos = i
				@arr[i] = tmp
				i = par
			else
				break
			end
		end
		i
	end

	def deleteMin #returns value at root, O(lg n)
		if(empty?)
			fail "Heap is empty"
		end
		m = @arr[0]
		@contents -= 1
		@arr[0] = @arr[@contents]
		@arr[0].pos = bubble_down(0)
		return m
	end

	#move object at position i down after deletion or key increase, O(lg n)
	def bubble_down(i)
		l = lchild(i)
		r = rchild(i)
		while(l < @contents-1) #guarantees both children aren't nil
			m = @arr[l].min(@arr[r])
			j = m.pos 
			if m < @arr[i] #flip comparisons if maxheap
					#swap parent and child
					@arr[j] = @arr[i]
					@arr[i] = m
					m.pos = i
					i = j
			else 
				break #in correct position
			end
			l = lchild(i)
			r = rchild(i)
		end
		if l == @contents-1 and (@arr[l] < @arr[i]) #rchild is necessarily nil, check lchild
			m = @arr[l]
			@arr[l] = @arr[i]
			@arr[i] = m
			m.pos = i
			i = l
		end
		i
	end

	def parent(i)
		return (i-1)/2
	end

	def lchild(i)
		return 2*i + 1
	end

	def rchild(i)
		return 2*i + 2
	end
end

=begin

b = BinaryHeap.new()
k = Node.new("hello", 0)

t = [5,3,2,10,9,0,4]
w = ["hello","world","I","want","more","data","structures"]
keys = Array.new(7)

for i in 0..6 do
	keys[i] = Node.new(w[i],t[i])
end

keys.each do |i|
	b.insert(i)
end

b.updateKey(keys[0],-1)
b.updateKey(keys[4],-2)

while(not b.empty?)
	puts b.deleteMin
end

=end