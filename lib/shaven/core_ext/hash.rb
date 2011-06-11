module Shaven
  module CoreExt
    # Contains helpers for keys stringifying. Implementation borrowed from activesupport. 
    module Hash
      def stringify_keys
        inject({}) { |options, (key, value)|
          options[key.to_s] = value
          options
        }
      end

      def stringify_keys!
        keys.each { |key| self[key.to_s] = delete(key) }
        self
      end
    end # Hash
  end # CoreExt
end # Shaven

class Hash
  include Shaven::CoreExt::Hash
end
