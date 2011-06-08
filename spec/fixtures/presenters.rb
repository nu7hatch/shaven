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
