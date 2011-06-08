module Shaven
  class Tag < Nokogiri::XML::Node
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
      
      attrs.stringify_keys.each { |key,value| 
        self.set_attribute(key.to_s, value) 
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
  end # Tag
end # Shaven
