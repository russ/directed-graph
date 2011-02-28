module DirectedGraph
  class Graph
    def initialize(name, params = {})
      @redis = Redis::Namespace.new(name, :redis => Redis.new(params))
    end

    def add_node(node)
      @redis.sadd(:nodes, node.to_json)
      node
    end

    def add_edge(edge)
      @redis.sadd(
        DirectedGraph::identifier("ajdacency", edge.source.id),
        edge.to_json)
        edge
    end

    def nodes
      @redis.smembers(:nodes).collect do |n|
        node = JSON.parse(n)
        Node.new(node["name"], node["attributes"])
      end
    end
    
    def edges(node)
      @redis.smembers(DirectedGraph::identifier("ajdacency", node.id)).collect do |e|
        edge = JSON.parse(e)
        source = JSON.parse(edge["source"])
        target = JSON.parse(edge["target"])

        Edge.new(
          Node.new(source["name"], source["attributes"]),
          Node.new(target["name"], target["attributes"]))
      end
    end
  end
end
