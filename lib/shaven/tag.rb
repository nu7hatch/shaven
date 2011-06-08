module Shaven
  class Tag < Nokogiri::XML::Node
    UJS_DATA_ATTRIBUTES = { 'remote' => true, 'confirm' => false, 'method' => false }

    class << self
      alias_method :orig_new, :new

      def new(name, attrs, content, document)
        node = orig_new(name.to_s, document)
        node.update!(attrs, content.respond_to?(:call) ? content.call : content)
      end

      def cast(orig)
        new(orig.name, orig.attributes, orig.content, orig.document)
      end
    end

    def update!(attrs={}, content=nil, &block)
      content = block.call if block_given?
      attrs = apply_ujs_data_attributes(attrs.stringify_keys)
      
      attrs.each { |key,value|
        if value === false
          delete(key.to_s)
        else
          self[key.to_s] = value.to_s
        end
      }
      
      if content.is_a?(Tag)
        self.inner_html = content
      elsif !content.nil?
        self.content = content
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
  end # Tag
end # Shaven
