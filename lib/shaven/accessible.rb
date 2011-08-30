module Shaven
  module AccessibleState
    def shaven_accessible?
      true
    end
  end # AccessibleState

  module Accessible
    include AccessibleState

    def self.included(base)
      base.send :include, AccessibleState
      base.send :alias_method, :key?, :respond_to?
      base.send :alias_method, :[], :send
    end
  end # Accessible
end # Shaven
