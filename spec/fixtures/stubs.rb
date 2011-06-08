class Spartan
  attr_reader :name, :title, :motto
  
  def initialize(name, title, motto)
    @name, @title, @motto = name, title, motto
  end

  def to_shaven
    { :name => name, :title => title, :motto => motto }
  end
end
