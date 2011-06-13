require File.dirname(__FILE__) + "/../spec_helper"

class ConditionPresenter < Shaven::Presenter
  def true?
    true
  end

  def false?
    false
  end
end

describe Shaven::Transformer::Condition do
  subject do 
    Shaven::Transformer::Condition 
  end

  it "always can be transformed" do
    subject.can_be_transformed?(nil).should be_true
  end
  
  describe "transform!" do
    it "removes given node when condition is false" do
      p = make_presenter("condition.html", ConditionPresenter)
      p.to_html.should == "<!DOCTYPE html>\n<html><body>\n\n<div>This should appear!</div>\n</body></html>\n"
    end
  end
end
