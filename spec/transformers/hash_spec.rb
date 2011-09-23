require File.dirname(__FILE__) + "/../spec_helper"

class HashPresenter < Shaven::Presenter
  def user
    { :name => "Marty Macfly", :email => "marty@macfly.com" }
  end
end

describe Shaven::Transformer::Hash do
  subject do 
    Shaven::Transformer::Hash 
  end

  it "can be transformed when value is an Hash" do
    subject.can_be_transformed?({:foo => "bar"}).should be_true
    subject.can_be_transformed?(nil).should be_false
  end
  
  describe "transform!" do
    it "scopes given hash value as subcontext" do
      p = render("context.html", HashPresenter)
      p.should == "<!DOCTYPE html>\n<html><body>\n<div>\n<h2>Marty Macfly</h2>\n<p>marty@macfly.com</p>\n</div>\n</body></html>\n"
    end
  end
end
