module Shaven
  class Transformer
    # Its job is to automatically recognize which transformer should be applied
    # using specified settings. Regocnition is done by matching value type.
    class Auto < Transformer
      self.caller_key = 'fill'

      def self.new(name, value, scope)
        match_transformer(value).new(name, value, scope)
      end

      def self.match_transformer(value)
        if Hash.can_be_transformed?(value)
          self::Hash
        elsif Object.can_be_transformed?(value)
          self::Object
        elsif List.can_be_transformed?(value)
          self::List
        else
          self::TextOrNode
        end
      end
    end # Auto
  end # Transformer
end # Shaven
