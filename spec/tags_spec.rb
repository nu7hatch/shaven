require File.dirname(__FILE__) + "/spec_helper"

describe Shaven::Tag do
  let (:doc) { Nokogiri::HTML("<html><body></body></html>") }
  subject { Shaven::Tag.new(:div, {}, "Test!", doc) }

  describe ".new" do
    it "creates node with given name, attrs and content within given document" do
      tag = Shaven::Tag.new('div', {:id => "foobar"}, "My content", doc)
      tag.to_html.should == '<div id="foobar">My content</div>'
    end

    it "creates node with content passed as proc" do
      tag = Shaven::Tag.new('div', {}, proc { "Fooo!" }, doc)
      tag.to_html.should == '<div>Fooo!</div>'
    end

    it "creates empty tag when nil content given" do
      tag = Shaven::Tag.new('div', {}, nil, doc)
      tag.to_html.should == '<div></div>'
    end

    it "creates proper no-content tags" do
      tag = Shaven::Tag.new('img', {:src => 'foo.jpg'}, "Should be ignored!", doc)
      tag.to_html.should == '<img src="foo.jpg">'
    end
  end

  describe "#replacement?" do
    it "returns false by default" do
      subject.should_not be_replacement
    end
  end

  describe "#replace!" do
    it "returns self tag marked as replacement" do
      rep = subject.replace!
      rep.should be_replacement
      rep.should == subject
    end
  end
end
