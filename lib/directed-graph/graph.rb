module DirectedGraph
  class Graph
    def initialize(name, params = {})
      @redis = Redis::Namespace.new(name, :redis => Redis.new(params))
    end

    def add_node(node)
      @redis.zadd(
        :nodes,
        (edges(node).count || 0),
        node.to_json)
      node
    end

    def add_edge(edge)
      @redis.zadd(
        DirectedGraph::identifier("ajdacency", edge.source.id),
        (edges(edge.source).count || 1),
        edge.to_json)
      edge
    end

    def nodes(min = 0, max = -1)
      @redis.zrevrange(:nodes, min, max).collect do |n|
        node = JSON.parse(n)
        Node.new(node["name"], node["attributes"])
      end
    end
    
    def edges(node, min = 0, max = -1)
      @redis.zrevrange(DirectedGraph::identifier("ajdacency", node.id), min, max).collect do |e|
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
