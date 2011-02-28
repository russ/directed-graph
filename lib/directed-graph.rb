require "digest/sha2"
require 'redis'
require 'redis-namespace'
require 'json'
require 'base64'

module DirectedGraph
  autoload :Node, "directed-graph/node"
  autoload :Edge, "directed-graph/edge"
  autoload :Graph, "directed-graph/graph"

  def self.identifier(*args)
    Digest::SHA2.hexdigest(args.join.downcase)
  end
end
