module DirectedGraph
  class Node
    attr_accessor :id, :name, :attributes

    def initialize(name, attributes = {})
      @id, @name, @attributes = DirectedGraph::identifier(name), name, attributes
    end

    def to_json
      { :id => @id, 
        :name => @name, 
        :attributes => @attributes }.to_json
    end
  end
end
