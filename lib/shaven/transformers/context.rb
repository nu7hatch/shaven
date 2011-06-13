module Shaven
  module Transformer
    # This transformer Can be applied only when value is an instance of +Hash+,
    # <tt>Shaven::Scope</tt>, or <tt>Shaven::Preseneter</tt>. It doesn't modify
    # anything within given node, but modifies context for childrens.
    #
    # ==== Example
    #
    #   <div rb="user">
    #     <div rb="name">John Doe</div>
    #     <div rb="email">email@example.com</div>
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
    class Context < Base
      def self.can_be_transformed?(value)
        value.is_a?(::Hash)
      end
      
      def transform!
        value.stringify_keys
      end
    end # Context
  end # Transformer
end # Shaven
