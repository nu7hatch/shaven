require File.dirname(__FILE__) + "/../spec_helper"

class ReverseConditionPresenter < Shaven::Presenter
  def true?
    true
  end

  def false?
    false
  end
end

describe Shaven::Transformer::ReverseCondition do
  subject do 
    Shaven::Transformer::ReverseCondition 
  end

  it "always can be transformed" do
    subject.can_be_transformed?(nil).should be_true
  end
  
  describe "transform!" do
    it "removes given node when condition is true" do
      p = make_presenter("reverse_condition.html", ReverseConditionPresenter)
      p.to_html.should == "<!DOCTYPE html>\n<html><body>\n\n<div>This should appear!</div>\n</body></html>\n"
    end
  end
end
