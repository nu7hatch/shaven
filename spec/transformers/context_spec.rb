require File.dirname(__FILE__) + "/../spec_helper"

class ContextPresenter < Shaven::Presenter
  def user
    { :name => "Marty Macfly", :email => "marty@macfly.com" }
  end
end

describe Shaven::Transformer::Context do
  subject do 
    Shaven::Transformer::Context 
  end

  it "can be transformed when value is an Hash" do
    subject.can_be_transformed?({:foo => "bar"}).should be_true
    subject.can_be_transformed?(nil).should be_false
  end
  
  describe "transform!" do
    it "scopes given hash value as subcontext" do
      p = make_presenter("context.html", ContextPresenter)
      p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<div>\n<h2>Marty Macfly</h2>\n<p>marty@macfly.com</p>\n</div>\n</body></html>\n"
    end
  end
end
