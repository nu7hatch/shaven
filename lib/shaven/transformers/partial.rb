module Shaven
  module Transformer
    class Partial < Base
      def self.find_value(scope, key)
        nil
      end

      def transform!
        content = scope.last.partial(name.to_s)
        parent = node.parent
        parent.add_child(parent.parse(content))
        node.remove
          
        #if content.shaven?
          Transformer.apply!(scope.with(parent))
        #end

        nil
      end
    end # Context
  end # Transformer
end # Shaven
