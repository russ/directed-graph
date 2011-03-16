module DirectedGraph
  class Edge
    attr_accessor :id, :source, :target, :weight

    def initialize(source, target, weight = 0)
      @id = DirectedGraph::identifier('edge', source.id, target.id)
      @source, @target, @weight = source, target, weight
    end

    def to_json
      { :id => @id,
        :source => @source.to_json, 
        :target => @target.to_json,
        :weight => @weight }.to_json
    end
  end
end
