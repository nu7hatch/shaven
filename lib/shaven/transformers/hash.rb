module Shaven
  class Transformer
    # This transformer Can be applied only when value is an instance of +Hash+,
    # <tt>Shaven::Scope</tt>, or <tt>Shaven::Preseneter</tt>. It doesn't modify
    # anything within given node, but modifies context for childrens.
    #
    # ==== Example
    #
    #   <div data-fill="user">
    #     <div data-fill="name">John Doe</div>
    #     <div data-fill="email">email@example.com</div>
    #   </div>
    #
    # applied with given value:
    #
    #   { :name => "Marty Macfly", :email => "marty@macf.ly" }
    #
    # ... generates:
    #
    #   <div>
    #     <div>Marty Macfly</div>
    #     <div>marty@macf.ly</div>
    #   </div>
    #
    class Hash < Transformer
      def self.can_be_transformed?(value)
        value.respond_to?(:to_hash)
      end
      
      def transform!
        value.to_hash.stringify_keys
      end
    end # Context
  end # Transformer
end # Shaven
