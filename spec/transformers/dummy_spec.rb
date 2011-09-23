require File.dirname(__FILE__) + "/../spec_helper"

describe Shaven::Transformer::Dummy do
  subject do 
    Shaven::Transformer::Dummy 
  end

  it "always can be transformed" do
    subject.can_be_transformed?(nil).should be_true
  end
  
  describe "transform!" do
    it "removes given node" do
      p = render("dummy.html")
      p.should == "<!DOCTYPE html>\n<html><body>\n\n</body></html>\n"
    end
  end
end
