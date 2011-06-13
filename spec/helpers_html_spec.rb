require File.dirname(__FILE__) + "/spec_helper"

describe Shaven::Presenter do
  subject do
    Shaven::Presenter.feed("<html><body></body></html>")
  end

  describe "#tag" do
    it "creates element within current doc" do
      div = subject.tag(:div, :id => "foo") { "Hello!" }
      div.to_html.should == '<div id="foo">Hello!</div>'
    end

    it "creates element without attributes when not given" do
      div = subject.tag(:div) { "Hello!" }
      div.to_html.should == '<div>Hello!</div>'
    end
  end

  describe "#div" do
    it "creates new div element within current doc" do
      div = subject.div(:id => "foo") { "Hello!" }
      div.to_html.should == '<div id="foo">Hello!</div>'
    end

    it "creates new div element without arguments when not given" do
      div = subject.div { "Hello!" }
      div.to_html.should == '<div>Hello!</div>'
    end
  end

  describe "#img" do
    it "creates new img element within current doc" do
      img = subject.img(:src => "foo.jpg")
      img.to_html.should == '<img src="foo.jpg">'
    end

    it "creates new img element without arguments when not given" do
      subject.img.to_html.should == '<img>'
    end
  end

  describe "#a" do
    it "creates new a element within current doc" do
      a = subject.a(:href => "foo.html") { "Hello!" }
      a.to_html.should == '<a href="foo.html">Hello!</a>'
    end

    it "creates new a element without arguments when not given" do
      a = subject.a { "Hello!"} 
      a.to_html.should == '<a>Hello!</a>'
    end
  end
end
