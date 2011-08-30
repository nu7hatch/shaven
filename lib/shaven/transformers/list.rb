module Shaven
  class Transformer
    # This transformer can be applied when value can be iterated (responds to <tt>#each</tt>).
    # It treats given node as template so generates sequence of clones for each list value, 
    # and finally removes original node.
    #
    # ==== Example
    #
    #   <ul id="users">
    #     <li data-fill="users">John Doe</li>
    #   </ul>
    #
    # applied with given value:
    #
    #   ["Emmet Brown", "Marty Macfly", "Biff Tannen"]
    #
    # ... generates:
    #
    #   <ul id="users">
    #     <li>Emmet Brown</li>
    #     <li>Marty Macfly</li>
    #     <li>Biff Tannen</li>
    #   </ul>
    #
    class List < Transformer
      def self.can_be_transformed?(value)
        value.respond_to?(:each_index)
      end

      def transform!
        array_scope = {}
        parent = node.parent
        id = 0

        value.each { |item|
          new_node = node.dup
          array_scope["__shaven_list_item_#{id}"] = item
          new_node[Shaven.caller_key_prefix + Auto.caller_key] = "__shaven_list_item_#{id}"
          parent.add_child(new_node)
          id += 1
        }

        node.remove
        array_scope = scope.dup.unshift(array_scope)
        self.class.apply!(array_scope.with(parent))
        
        nil
      end
    end # List
  end # Transformer
end # Shaven
