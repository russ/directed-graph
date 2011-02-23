require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include DirectedGraph

describe DirectedGraph do
  describe Node do
    it "should create a node object" do
      node = Node.new("node")

      node.name.should == "node"
      node.attributes.should == {}
      node.id.should == DirectedGraph::identifier("node")
    end
  end

  describe Edge do
    it "should create a node object" do
      source = Node.new("source")
      target = Node.new("target")
      edge = Edge.new(source, target)

      edge.source.should == source
      edge.target.should == target
      edge.id.should == DirectedGraph::identifier("edge", source.id, target.id)
    end
  end

  describe Graph do
    subject { Graph.new(:test) }
    let(:redis) { Redis::Namespace.new(:test, :redis => Redis.new) }

    before(:each) do
      redis.flushdb
    end

    it "should add nodes to the graph" do
      node = Node.new("node")
      subject.add_node(node).should == node
      subject.nodes.count.should == 1
    end

    it "should add edges to the graph" do
      source = subject.add_node(Node.new("source"))
      target = subject.add_node(Node.new("target"))
      edge = Edge.new(source, target)

      subject.add_edge(edge).should == edge
      subject.nodes.count.should == 2
      subject.edges(source).count.should == 1
      subject.edges(source)[0].source.name.should == source.name
      subject.edges(source)[0].target.name.should == target.name
    end
  end
end
