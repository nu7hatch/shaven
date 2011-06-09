require 'shaven/transformers/content'

module Shaven
  module Transformer
    class Conditional < Content
      MATCHING_NOT = /^not\:/

      def can_be_transformed?
        super && (subst_value === false || subst_value === true)
      end

      def allow_continue?
        false
      end

      def not?
        @not ||= !!(subst_name =~ MATCHING_NOT)
      end

      def subst
        @subst ||= scope[subst_name.gsub(MATCHING_NOT, '\\1')]
      end

      def normalize!
        node.delete('id')
      end
      
      def transform!
        node.remove if (subst_value && not?) or (!subst_value && !not?)
      end
    end # Conditional
  end # Transformer
end # Shaven
