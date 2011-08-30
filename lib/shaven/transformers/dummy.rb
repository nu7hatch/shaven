module Shaven
  class Transformer
    # It removes all nodes containing <tt>rb:dummy</tt> attribute. It's very
    # usefull when your template contains lot of example items. Instead of deleting
    # them manualy you can mark them as dummy, so your designer can in the future
    # edit templates directly in application. 
    #
    # ==== Example
    # 
    #   <ul id="emperors">
    #     <li data-fill="emperors">Karol the Great</li>
    #     <li data-dummy="yes">Julius Cesar</li>
    #     <li data-dummy="yes">Alexander the Great</li>
    #   <ul>
    # 
    class Dummy < Transformer
      self.caller_key = 'dummy'

      def transform!
        node.remove
      end
    end # Dummy
  end # Transformer
end # Shaven
