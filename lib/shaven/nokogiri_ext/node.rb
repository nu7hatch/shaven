module Shaven
  module NokogiriExt
    module Node
      # List of extra <tt>data-*</tt> attributes for dealing with unobtrusive javascript
      # stuff. Following attributes will be converted to html compilant attrs. The <tt>true</tt>
      # and <tt>false</tt> values here means if attribute is boolean or not.
      UJS_DATA_ATTRIBUTES = { 
        'remote'  => true, 
        'confirm' => false, 
        'method'  => false 
      }

      # Helper for easy updating node's attributes and content. 
      #
      # ==== Example
      #   
      #   node.update!(:id => "hello-world").to_html # => <div id="hello-world"></div>
      #   node.update!(nil, "Foo!").to_html          # => <div id="hello-world">Foo!</div>
      #   node.update! { "Foobar!" }                 # => <div id="hello-world">Foobar!</div>
      #   node.update!(:id => false)                 # => <div>Foobar!</div>
      #
      def update!(attrs={}, content=nil, &block)
        attrs = {} unless attrs
        attrs = apply_ujs_data_attributes(attrs.stringify_keys)
        
        # Applying attributes...
        attrs.each { |key,value|
          if value === false
            delete(key.to_s)
          else
            self[key.to_s] = value.to_s
          end
        }

        content = block.call if block_given?
        
        # Applying content...
        if content.is_a?(Nokogiri::XML::Node)
          self.inner_html = content
        elsif !content.nil?
          self.content = content.to_s
        end

        return self
      end

      # Helper for replacing current node with other text or node. 
      #
      # ==== Example
      #
      #   node.replace!(other_node)
      #   node.replace!("Text")
      #   node.replace! { "Something new" }
      #
      # XXX: replace/replace_node method failed with segfault so this is some workaround...
      #
      def replace!(text_or_node=nil, &block)
        text_or_node = block.call if block_given?
        
        unless text_or_node.nokogiri_node?
          content, text_or_node = text_or_node.to_s, Nokogiri::XML::Text.new("dummy", document)
          text_or_node.content = content
        end
        
        node = add_previous_sibling(text_or_node)
        remove
      end

      private

      def apply_ujs_data_attributes(attrs)
        UJS_DATA_ATTRIBUTES.each { |key, bool|
          if attrs.key?(key)
            value = attrs.delete(key)
            attrs["data-#{key}"] = value ? (bool ? "data-#{key}" : value) : false
          end
        }
        return attrs
      end
    end # Node
  end # NokogiriExt
end # Shaven

class Nokogiri::XML::Node
  include Shaven::NokogiriExt::Node
end
