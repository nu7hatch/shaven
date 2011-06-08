module Shaven
  class Tag < Nokogiri::XML::Node
    class << self
      alias_method :orig_new, :new

      def new(name, attrs, content, document)
        node = orig_new(name.to_s, document)
        node.update!(attrs, content.respond_to?(:call) ? content.call : content)
      end
    end

    module InstanceMethods
      UJS_DATA_ATTRIBUTES = { 'remote' => true, 'confirm' => false, 'method' => false }

      def update!(attrs={}, content=nil, &block)
        attrs = {} unless attrs
        attrs = apply_ujs_data_attributes(attrs.stringify_keys)
        
        attrs.each { |key,value|
          if value === false
            delete(key.to_s)
          else
            self[key.to_s] = value.to_s
          end
        }

        content = block.call if block_given?
        
        if content.is_a?(Nokogiri::XML::Node)
          self.inner_html = content
        elsif !content.nil?
          self.content = content.to_s
        end

        return self
      end

      def replace!
        @replacement = true
        return self
      end

      def replacement?
        !!@replacement
      end

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
    end # InstanceMethods
  end # Tag
end # Shaven

class Nokogiri::XML::Node
  include Shaven::Tag::InstanceMethods
end
