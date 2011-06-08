require File.dirname(__FILE__) + "/spec_helper"
require File.dirname(__FILE__) + "/fixtures/presenters"

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

  def make_presenter(presenter, file)
    html = File.read(File.expand_path("../fixtures/#{file}", __FILE__))
    presenter.feed(html)
  end

  describe "contents completion" do
    describe "fill in" do
      it "puts content into tags with 'rb' attribute" do
        p = make_presenter(SimpleTestPresenter, 'simple.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<div id=\"leonidas\">This is sparta!!!</div>\n</body></html>\n"
      end

      it "replaces tag when replacement defined" do
        p = make_presenter(ReplacementTestPresenter, 'simple.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<h1 id=\"leonidas_words\">This is sparta!!!</h1>\n</body></html>\n"
      end

      it "updates original tag when updated" do
        p = make_presenter(UpdatingTestPresenter, 'simple.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<div id=\"leonidas\" class=\"words\">Sparta!!!</div>\n</body></html>\n"
      end

      it "properly deals with hash sub-contexts" do
        p = make_presenter(HashContextsTestPresenter, 'contexts.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<h1>Hello world!</h1>\n<div>\n<h2>Leonidas</h2>\n<p>King of Sparta</p>\n<blockquote>This is Sparta!!!</blockquote>\n</div>\n</body></html>\n"
      end
    end
  end
end
