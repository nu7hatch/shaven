require File.dirname(__FILE__) + "/../spec_helper"

class TextPresenter < Shaven::Presenter
  def value
    "Hello World!"
  end
end

class NodePresenter < Shaven::Presenter
  def value
    tag(:h1, :id => "title") { "Hello World!" }
  end
end

class UpdatesPresenter < Shaven::Presenter
  def value(node)
    node.update!(:id => "hello") { "Hello World!" }
  end
end

class ReplacementsPresenter < Shaven::Presenter
  def value(node)
    node.replace!(tag(:h1) { "Hello World!" })
  end
end

describe Shaven::Transformer::TextOrNode do
  subject do 
    Shaven::Transformer::TextOrNode 
  end

  it "always can be transformed" do
    subject.can_be_transformed?(nil).should be_true
  end
  
  describe "transform!" do
    context "when text given" do
      it "updates node's content" do
        p = render("text_or_node.html", TextPresenter)
        p.should == "<!DOCTYPE html>\n<html><body>\n<div>Hello World!</div>\n</body></html>\n"
      end
    end

    context "when node given" do
      it "inserts it into current node" do
        p = render("text_or_node.html", NodePresenter)
        p.should == "<!DOCTYPE html>\n<html><body>\n<div><h1 id=\"title\">Hello World!</h1></div>\n</body></html>\n"
      end
    end

    context "when original node" do
      it "updates it" do
        p = render("text_or_node.html", UpdatesPresenter)
        p.should == "<!DOCTYPE html>\n<html><body>\n<div id=\"hello\">Hello World!</div>\n</body></html>\n"
      end
    end

    context "when presenter replaces node" do
      it "works properly" do
        p = render("text_or_node.html", ReplacementsPresenter)
        p.should == "<!DOCTYPE html>\n<html><body>\n<h1>Hello World!</h1>\n</body></html>\n"
      end
    end

    context "when item not found" do
      it "deletes element" do
        p = render("text_or_node.html", Hash)
        p.should == "<!DOCTYPE html>\n<html><body>\n\n</body></html>\n"
      end
    end
  end
end
