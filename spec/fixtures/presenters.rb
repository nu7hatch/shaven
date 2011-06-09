require File.dirname(__FILE__) + "/stubs"

class SimpleTestPresenter < Shaven::Presenter
  def leonidas_says
    "This is sparta!!!"
  end
end

class ReplacementTestPresenter < Shaven::Presenter
  def leonidas_says
    tag(:h1, :id => "leonidas_words") { "This is sparta!!!" }.replace!
  end
end

class InsertingTestPresenter < Shaven::Presenter
  def leonidas_says
    tag(:strong) { "This is sparta!!!" }
  end
end

class UpdatingTestPresenter < Shaven::Presenter
  def leonidas_says(orig)
    orig.update!(:class => "words") { "Sparta!!!" }
  end
end

class HashContextsTestPresenter < Shaven::Presenter
  def leonidas_info
    { :name  => "Leonidas", 
      :title => "King of Sparta", 
      :motto => "This is Sparta!!!"
    }
  end

  def title
    "Hello world!"
  end
end

class ToShavenContextsTestPresenter < Shaven::Presenter
  def leonidas_info
    Spartan.new("Leonidas", "King of Sparta", "This is Sparta!!!")
  end

  def title
    "Hello world!"
  end
end

class SimpleArrayTestPresenter < Shaven::Presenter
  def colors
    ["yellow", proc { |orig| orig.update!(:class => "red") { "red" } }, "green", "blue"]
  end
end

class ComplexArrayTestPresenter < Shaven::Presenter
  def spartans
    [ Spartan.new("Dilios", "Soldier", "Foobar"),
      Spartan.new("Theron", "Soldier", "Bla"),
      Spartan.new("Daxos", "Soldier", "Fooo"),
      Spartan.new("Leonidas", "King", "This is Sparta!!!")
    ]
  end
end

class ConditionalsTestPresenter < Shaven::Presenter
  def logged_in?
    false
  end
end
