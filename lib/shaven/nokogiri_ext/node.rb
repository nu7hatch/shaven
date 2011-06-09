module Shaven
  module NokogiriExt
    module Node
      # List of extra <tt>data-*</tt> attributes for dealing with unobtrusive javascript
      # stuff. Following attributes will be converted to html compilant attrs. The <tt>true</tt>
      # and <tt>false</tt> values here means if attribute is boolean or not.
      UJS_DATA_ATTRIBUTES = { 'remote' => true, 'confirm' => false, 'method' => false }

      # Helper for easy updating node's attributes and content. 
      #
      # ==== Example
      #   
      #   node.update(:id => "hello-world").to_html # => <div id="hello-world"></div>
      #   node.update(nil, "Foo!").to_html          # => <div id="hello-world">Foo!</div>
      #   node.update { "Foobar!" }                 # => <div id="hello-world">Foobar!</div>
      #   node.update(:id => false)                 # => <div>Foobar!</div>
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

      # Sets replacement status to true. It means currently transformed node will be replaced
      # with this one. 
      def replace!
        @replacement = true
        return self
      end

      # Returns +true+ when replacement status is on. 
      def replacement?
        !!@replacement
      end

      # Returns +true+ when replacement status if on or given tag equals represented one. 
      def replace_with?(origin)
        replacement? or origin === self
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
