require File.dirname(__FILE__) + "/../spec_helper"

class Foobar
  include Shaven::Accessible
  
  def foo
    "bar"
  end
end

describe Shaven::Transformer::Auto do
  subject do 
    Shaven::Transformer::Auto 
  end

  it "always can be transformed" do
    subject.can_be_transformed?(nil).should be_true
  end

  describe ".new" do
    context "when value is an array" do
      it "returns list transformer object" do
        t = Shaven::Transformer::Auto.new("value", [1,2,3], Shaven::Scope.new({}))
        t.should be_kind_of(Shaven::Transformer::List)
      end
    end

    context "when value is an hash" do
      it "returns context transformer object" do
        t = Shaven::Transformer::Auto.new("value", {:foo => "bar"}, Shaven::Scope.new({}))
        t.should be_kind_of(Shaven::Transformer::Hash)
      end
    end

    context "when value is an shaven accessible object" do
      it "returns context transformer object" do
        t = Shaven::Transformer::Auto.new("value", Foobar.new, Shaven::Scope.new({}))
        t.should be_kind_of(Shaven::Transformer::Object)
      end
    end

    context "otherwise" do
      it "returns `text or node` transformer object" do
        t = Shaven::Transformer::Auto.new("value", "Foo!", Shaven::Scope.new({}))
        t.should be_kind_of(Shaven::Transformer::TextOrNode)
      end
    end
  end
end
