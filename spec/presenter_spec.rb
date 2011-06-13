require File.dirname(__FILE__) + "/spec_helper"

describe Shaven::Presenter do
  describe ".feed" do
    it "creates instance of given presenter for given html" do
      p = Shaven::Presenter.feed("<!DOCTYPE html><html><body>Hello!</body></html>")
      p.to_html.should == "<!DOCTYPE html>\n<html><body>Hello!</body></html>\n"
    end
  end

  describe "#to_html" do
    it "generates html code from presenter data" do
      # tested in `.feed` examples
    end

    context "when context given" do
      it "combines it with current scope" do
        p = make_presenter("text_or_node.html")
        p.to_html(:value => "Hello Context!").should == "<!DOCTYPE html>\n<html><body>\n<div>Hello Context!</div>\n</body></html>\n"
      end
    end
  end

  describe "#compiled" do
    it "returns false before first render" do
      p = make_presenter("text_or_node.html")
      p.should_not be_compiled
    end

    it "returns true after first render" do
      p = make_presenter("text_or_node.html")
      p.to_html(:value => "Hello!")
      p.should be_compiled
    end
  end
end
