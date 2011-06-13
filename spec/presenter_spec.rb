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
  end
end
