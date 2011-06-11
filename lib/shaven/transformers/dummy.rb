module Shaven
  module Transformer
    # It removes all nodes containing <tt>rb:dummy</tt> attribute. It's very
    # usefull when your template contains lot of example items. Instead of deleting
    # them manualy you can mark them as dummy, so your designer can in the future
    # edit templates directly in application. 
    #
    # ==== Example
    # 
    #   <ul id="emperors">
    #     <li rb="emperors">Karol the Great</li>
    #     <li rb:dummy="yes">Julius Cesar</li>
    #     <li rb:dummy="yes">Alexander the Great</li>
    #   <ul>
    # 
    class Dummy < Base
      def transform!
        node.remove
      end
    end # Dummy
  end # Transformer
end # Shaven
