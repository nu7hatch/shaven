module Shaven
  module Transformer
    # Its job is to automatically recognize which transformer should be applied
    # using specified settings. Regocnition is done by matching value type.
    class Auto < Base
      def self.new(name, value, scope)
        if Context.can_be_transformed?(value)
          Context.new(name, value, scope)
        elsif List.can_be_transformed?(value)
          List.new(name, value, scope)
        else
          TextOrNode.new(name, value, scope)
        end
      end
    end # Auto
  end # Transformer
end # Shaven
