require File.dirname(__FILE__) + "/spec_helper"

describe Nokogiri::XML::Node do
  let(:doc) do
    Nokogiri::HTML("<html><body></body></html>")
  end

  let(:node) do
    Nokogiri::XML::Node.new("div", doc) 
  end

  describe "#update!" do
    it "updates attributes and content" do
      node.update!({:id => "test"}, "Foobar!")
      node.content.should == "Foobar!"
      node['id'].should == "test"
    end

    context "when attribute is set to false" do
      it "removes it" do
        node['id'] = "test"
        node.update! :id => false
        node['id'].should_not be
      end
    end

    context "when block given" do
      it "treats it as content" do
        node.update! { "Hello world!" }
        node.content.should == "Hello world!"
      end
    end

    context "when UJS attrs given" do
      it "converts them properly to html attributes" do
        node.update! :method => 'post', :remote => 'true', :confirm => "Are you sure?"
        node['data-method'].should == 'post'
        node['data-remote'].should == 'data-remote'
        node['data-confirm'].should == 'Are you sure?'
      end
    end
  end

  describe "#replace!" do
    let(:other_node) do 
      other_node = Nokogiri::XML::Node.new("p", doc)
      other_node.content = "Other node!"
      other_node
    end

    it "replaces node with given text or other node" do
      # tested in other place...
    end
  end
end
