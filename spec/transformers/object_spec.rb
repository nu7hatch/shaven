require File.dirname(__FILE__) + "/../spec_helper"

class BiffObject
  shaven_accessible!

  def name
    "Biff Tannen"
  end
  
  def email
    "biff@tannen.com"
  end
end

class ObjectPresenter < Shaven::Presenter
  def user
    BiffObject.new
  end
end

describe Shaven::Transformer::Object do
  subject do 
    Shaven::Transformer::Object
  end

  it "can be transformed when value is an Hash" do
    subject.can_be_transformed?(BiffObject.new).should be_true
    subject.can_be_transformed?(nil).should be_false
  end
  
  describe "transform!" do
    it "scopes given object as subcontext if it's shaven accessible" do
      p = make_presenter("context.html", ObjectPresenter)
      p.to_html.should == "<!DOCTYPE html>\n<html><body>\n<div>\n<h2>Biff Tannen</h2>\n<p>biff@tannen.com</p>\n</div>\n</body></html>\n"
    end
  end
end
