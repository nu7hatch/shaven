module Shaven
  class Node < Nokogiri::XML::Node
    class << self
      alias_method :orig_new, :new

      def new(name, attrs, content, document)
        node = orig_new(name.to_s, document)
        node.update!(attrs, content.respond_to?(:call) ? content.call : content)
      end
    end # self
  end # Node
end # Shaven
