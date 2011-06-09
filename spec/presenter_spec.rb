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
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<div id=\"leonidas_says\">This is sparta!!!</div>\n</body></html>\n"
      end

      it "replaces tag when replacement defined" do
        p = make_presenter(ReplacementTestPresenter, 'simple.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<h1 id=\"leonidas_words\">This is sparta!!!</h1>\n</body></html>\n"
      end
      
      it "inserts given tag within current" do
        p = make_presenter(InsertingTestPresenter, 'simple.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<div id=\"leonidas_says\"><strong>This is sparta!!!</strong></div>\n</body></html>\n"
      end

      it "updates original tag when updated" do
        p = make_presenter(UpdatingTestPresenter, 'simple.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<div id=\"leonidas_says\" class=\"words\">Sparta!!!</div>\n</body></html>\n"
      end

      it "properly deals with hash sub-contexts" do
        p = make_presenter(HashContextsTestPresenter, 'contexts.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<h1 id=\"title\">Hello world!</h1>\n<div id=\"leonidas_info\">\n<h2 id=\"leonidas_info_name\">Leonidas</h2>\n<p id=\"leonidas_info_title\">King of Sparta</p>\n<blockquote id=\"leonidas_info_motto\">This is Sparta!!!</blockquote>\n</div>\n<div id=\"title\">Hello world!</div>\n</body></html>\n"
      end

      it "properly deals with to_shaven like sub-contexts" do
        p = make_presenter(ToShavenContextsTestPresenter, 'contexts.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<h1 id=\"title\">Hello world!</h1>\n<div id=\"leonidas_info\">\n<h2 id=\"leonidas_info_name\">Leonidas</h2>\n<p id=\"leonidas_info_title\">King of Sparta</p>\n<blockquote id=\"leonidas_info_motto\">This is Sparta!!!</blockquote>\n</div>\n<div id=\"title\">Hello world!</div>\n</body></html>\n"
      end

      it "properly deals with array contexts" do
        p = make_presenter(SimpleArrayTestPresenter, 'arrays.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<ul>\n<li id=\"color_1\">yellow</li>\n<li id=\"color_2\" class=\"red\">red</li>\n<li id=\"color_3\">green</li>\n<li id=\"color_4\">blue</li>\n</ul>\n</body></html>\n"
      end
      
      it "properly deals with complex array/hash contexts" do
        p = make_presenter(ComplexArrayTestPresenter, 'complex.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<ul id=\"spartans\">\n<li id=\"spartan_1\">\n<h2 id=\"spartan_name\">Dilios</h2>\n<p id=\"spartan_title\">Soldier</p>\n<blockquote id=\"spartan_motto\">Foobar</blockquote>\n</li>\n<li id=\"spartan_2\">\n<h2 id=\"spartan_name\">Theron</h2>\n<p id=\"spartan_title\">Soldier</p>\n<blockquote id=\"spartan_motto\">Bla</blockquote>\n</li>\n<li id=\"spartan_3\">\n<h2 id=\"spartan_name\">Daxos</h2>\n<p id=\"spartan_title\">Soldier</p>\n<blockquote id=\"spartan_motto\">Fooo</blockquote>\n</li>\n<li id=\"spartan_4\">\n<h2 id=\"spartan_name\">Leonidas</h2>\n<p id=\"spartan_title\">King</p>\n<blockquote id=\"spartan_motto\">This is Sparta!!!</blockquote>\n</li>\n</ul>\n</body></html>\n"
      end

      it "properly deals with conditionals" do
        p = make_presenter(ConditionalsTestPresenter, 'conditionals.html')
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n\n<div>Yeah, you're not logged in!</div>\n</body></html>\n"
      end
    end
  end
end
