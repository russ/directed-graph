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

    it "should ..." do
      words = [ "gift cards", "visa gift cards", "visa giftcards", "Virtual Gifts", "merchant cards", "Card", "gift certificate", "gift idea", "customize", "CenterState Bank", "Bank of Florida", "prepaid card", "prepaid visa", "incentive", "corporate reward", "personalized gift", "Cart", "Customer Service", "customized gifts", "capabilities", "gift cards", "favorite brands", "birthday gift", "graduation present", "card designs", "certificates", "online shopping", "Activate Gift Card", "Visa", "Shopping Cart", "Father's Day", "Mother's Day", "Back-to-School", "Christmas", "Hanukkah", "New Baby", "Shower", "Valentine's Day", "Wedding", "iTunes", "Gift Cards", "American Express", "Card", "purchase", "fees", "tab", "Prepaid Cards", "Business", "Membership Rewards", "Card purchase", "Small Business", "Corporate Cards", "Products", "Rewards", "Buy Business", "Business Cards", "Business Travel", "Personal Cards", "You Want", "restrictions", "gift cards", "Reward Cards", "Visa", "Visa Gift Cards", "corporate reward", "Vanilla", "e-Gift Cards", "gift certificates", "retailer", "eGift", "Amazon", "Gift Giving", "wellness", "Card", "District of Columbia", "American Express Reward", "wellness programs", "rewards", "e-gift certificates", "Wines", "gift cards", "card", "fees", "recipient", "consumer", "store", "expiration dates", "pitfalls", "bank", "Kmart", "closed loop", "national retailers", "Cash Card", "credit card", "free encyclopedia", "United States", "third party", "incentive", "cash" ]
      words.each { |w| subject.add_node(Node.new(w)) }
      edges = words.flat_map { |j| words.map { |k| ([ j, k ] unless j == k) }}.compact.uniq
      edges.each { |e| subject.add_edge(Edge.new(Node.new(e[0]), Node.new(e[1]))) }

      subject.nodes.count.should == 90

      edges = subject.edges(DirectedGraph::Node.new("gift cards"))
      edges.count.should == 178
    end
  end
end
