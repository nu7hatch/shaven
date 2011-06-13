require File.dirname(__FILE__) + "/../spec_helper"

class ListPresenter < Shaven::Presenter
  def users
    ["Emmet Brown", "Marty Macfly", "Biff Tannen"]
  end
end

class ListOfContextsPresenter < Shaven::Presenter
  def users
    [ {:name => proc { |node| node.replace!("Emmet Brown") }}, 
      {:name => "Marty Macfly"},
      {:name => "Biff Tannen"}
    ]
  end
end

describe Shaven::Transformer::List do
  subject do 
    Shaven::Transformer::List 
  end

  it "can be transformed when value is an Array" do
    subject.can_be_transformed?(nil).should be_false
    subject.can_be_transformed?([1,2,3]).should be_true
  end
  
  describe "transform!" do
    it "generates sequence based on current node and fills it in with list values" do
      p = make_presenter("list.html", ListPresenter)
      p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<ul>\n<li>Emmet Brown</li>\n<li>Marty Macfly</li>\n<li>Biff Tannen</li>\n</ul>\n</body></html>\n"
    end

    context "when list of hashes given" do
      it "generates sequence based on current node and scopes list items as subcontexts" do
        p = make_presenter("list_of_contexts.html", ListOfContextsPresenter)
        p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<ul>\n<li>Emmet Brown</li>\n<li><strong>Marty Macfly</strong></li>\n<li><strong>Biff Tannen</strong></li>\n</ul>\n</body></html>\n"
      end
    end
  end
end
