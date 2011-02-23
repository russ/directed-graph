module DirectedGraph
  class Edge
    attr_accessor :id, :source, :target

    def initialize(source, target)
      @id = DirectedGraph::identifier('edge', source.id, target.id)
      @source, @target = source, target
    end

    def to_json
      { :id => @id,
        :source => @source.to_json, 
        :target => @target.to_json }.to_json
    end
  end
end
