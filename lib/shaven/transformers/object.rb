module Shaven
  class Transformer
    # This transformer Can be applied only when value is an instance of shaven
    # accessible `Object`, It doesn't modify anything within given node, but 
    # modifies context for childrens.
    #
    # ==== Example
    #
    #   <div data-fill="user">
    #     <div data-fill="name">John Doe</div>
    #     <div data-fill="email">email@example.com</div>
    #   </div>
    #
    # applied with given object instance:
    #  
    #   class Marty
    #     def name
    #       "Marty Macfly"
    #     end
    #   
    #     def email
    #       "marty@macf.ly"
    #     end
    #   end
    #
    # ... generates:
    #
    #   <div>
    #     <div>Marty Macfly</div>
    #     <div>marty@macf.ly</div>
    #   </div>
    #
    class Object < Transformer
      def self.can_be_transformed?(value)
        value.shaven_accessible?
      end
      
      def transform!
        value
      end
    end # Context
  end # Transformer
end # Shaven
