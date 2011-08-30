module Shaven
  module CoreExt
    module Object
      def nokogiri_node?
        kind_of?(Nokogiri::XML::Node)
      end
      
      def to_shaven
        self
      end

      def shaven_accessible?
        false
      end
    end # Object
  end # CoreExt
end # Shaven

class Object
  include Shaven::CoreExt::Object
end
