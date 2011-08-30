module Shaven
  module CoreExt
    module Object
      def self.included(base)
        base.extend(ClassMethods)
      end

      def nokogiri_node?
        kind_of?(Nokogiri::XML::Node)
      end
      
      def to_shaven
        self
      end

      def shaven_accessible?
        false
      end

      module ClassMethods
        def shaven_accessible!
          define_method(:shaven_accessible?) { true }
          define_method(:key?) { |key| respond_to?(key) }
          define_method(:[]) { |key| send(key) }
        end
      end
    end # Object
  end # CoreExt
end # Shaven

class Object
  include Shaven::CoreExt::Object
end
