class Number < Struct.new(:value)
end

class Add < Struct.new(:left,:right)
end

class Multiply < Struct.new(:left,:right)
end

Add.new(
    Multiply.new(Number.new(1),Multiply.new(2)),
    Multiply.new(Number.new(3),Multiply.new(4))
)