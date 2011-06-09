module Shaven
  module CoreExt
    module Object
      def to_shaven_item(index=nil, indexer=nil)
        Shaven::Item.new(self, index, indexer)
      end
      
      def shaven_item?
        false
      end

      def shaven_node?
        kind_of?(Nokogiri::XML::Node)
      end
      
      def to_shaven
        self
      end
    end # Object
  end # CoreExt
end # Shaven

class Object
  include Shaven::CoreExt::Object
end
