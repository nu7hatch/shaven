require 'shaven/transformers/base'

module Shaven
  module Transformer
    class Dummy < Base
      def can_be_transformed?
        node['id'].to_s =~ /^(rb\:)?dummy$/ || node['data-dummy']
      end

      def allow_continue?
        false
      end

      def auto_normalize?
        false
      end
      
      def transform!
        node.remove
      end
    end # Dummy
  end # Transformer
end # Shaven
