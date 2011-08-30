module Shaven
  class Transformer
    # This transformer applies conditional operations to nodes. It applies to 
    # all nodes containing <tt>rb:if</tt> attribute.
    # 
    # See Also: <tt>Shaven::Transformer::ReverseCondition</tt>
    # 
    # ==== Example
    #
    #    <div data-if="logged_in?">
    #      Hello <span data-fill="user_name">John Doe</span>!
    #    </div>
    #
    class Condition < Transformer
      self.caller_key = 'if'

      def allow_continue?
        !!value
      end
      
      def transform!
        node.remove unless value
        nil
      end
    end # Condition
  end # Transformer
end # Shaven
