module Shaven
  class Transformer
    # This transformer applies reverse conditional operations to nodes. It applies 
    # to all nodes containing <tt>rb:unless</tt> attribute.
    # 
    # See Also: <tt>Shaven::Transformer::Condition</tt>
    # 
    # ==== Example
    #
    #    <div data-unless="logged_in?">
    #      <a href="#" data-fill="login_link">Login to your account!</a>
    #    </div>
    #
    class ReverseCondition < Transformer
      self.caller_key = 'unless'

      def allow_continue?
        !value
      end
      
      def transform!
        node.remove if value
        nil
      end
    end # ReverseCondition
  end # Transformer
end # Shaven
