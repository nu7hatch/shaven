module Shaven
  module Transformer
    # This transformers is applied to any kind of value which not applies to any 
    # other transformer. The only requirement is to node contains <tt>rb</tt> attribute.
    # If result is different than current node object then will be assigned as its 
    # content, otherwise nothin will happen (any updates goes in presenter then).
    #
    # === Example
    #
    #   <h1 rb="title">Example</h1>
    #   <p rb="description">Lorem ipsum dolor...</p>
    #
    # with given presenter:
    #
    #   class MyPresenter < Shaven::Presenter
    #     def title
    #       "Hello world!"
    #     end
    #   
    #     def description(node)
    #       node.update!(:id => "description") { "World is beautiful!" }
    #     end
    #   end
    #
    # ... generates:
    #
    #   <h1>Hello world!</h1>
    #   <p id="description">World is beautiful!</p>
    #
    class TextOrNode < Base
      def transform!
        if value.nokogiri_node?
          node.inner_html = value unless value === node
        else
          node.content = value.to_s
        end
        
        nil
      end
    end # TextOrNode
  end # Transformer
end # Shaven
