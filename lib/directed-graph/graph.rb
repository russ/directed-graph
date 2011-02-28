module DirectedGraph
  class Graph
    def initialize(name, options = {})
      @logger = options.delete(:logger)
      @redis = Redis::Namespace.new(name, :redis => Redis.new(options))
    end

    def add_node(node)
      @redis.sadd(:nodes, node.to_json)
      @logger.debug("Added Node #{node.id} (#{node.name})") if @logger
      node
    end

    def add_edge(edge)
      @redis.sadd(
        DirectedGraph::identifier("ajdacency", edge.source.id),
        edge.to_json)
      @logger.debug("Added Edge #{edge.id} (#{edge.source.name} => #{edge.target.name})") if @logger
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
