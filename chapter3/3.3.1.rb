module Pattern
	def bracket(outer_precedence)
		if precedence < outer_precedence
			'(' + to_s + ')'
		else
			to_s
		end
	end
	def inspect
		"/#{self}/"
	end
end

class Empty
	include Pattern

	def to_s
		''
	end
	def precedence
		3
	end
end

class Literal < Struct.new(:character)
	include Pattern

	def to_s
		character
	end

	def precedence
		3
	end
end

class Concatenate < Struct.new(:first, :second)
	include Pattern

	def to_s
		[first, second].map { |pattern| pattern.bracket(precedence) }.join('|')
	end

	def precedence
		0
	end
end

class Choose < Struct.new(:first, :second)
	include Pattern

	def to_s
		[first,second].map { |pattern| pattern.bracket(precedence) }.join('|')
	end
	def precedence
		0
	end
end

class Repeat < Struct.new(:pattern)
	include Pattern

	def to_s
		pattern.bracket(precedence) + '*'
	end
	def precedence
		2
	end
end

pattern = Repeat.new(
	Choose.new(
		Concatenate.new(Literal.new('a'), Literal.new('b')),
		Literal.new('a')
	)
)

class Empty
	def to_nfa_design
		start_state = Object.new
		accept_states = [start_state]
		rulebook = NFARulebook.new([])
		
		NFADesign.new(start_state, accept_states, rulebook)
	end
end

class Literal
	def to_nfa_design
		start_state = Object.new
		accept_state = Object.new
		rule = FARule.new(start_state, character, accept_state)
		rulebook = NFARulebook.new([rule])
		
		NFADesign.new(start_state, [accept_state], rulebook)
	end
end

nfa_design = Empty.new.to_nfa_design
nfa_design.accepts?('')
nfa_design.accepts?('a')

nfa_design = Literal.new('a').to_nfa_design
nfa_design.accepts?('')
nfa_design.accepts('a')
nfa_design.accepts('b')