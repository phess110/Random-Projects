class Node
	attr_accessor :val, :key, :pos

	def initialize(v, k)
		@val = v
		@key = k
		@pos
	end

	def <(other)
		@key < other.key
	end

	def min(b)
		return self < b ? self : b
	end
end