require 'shaven/transformers/base'
require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'

module Shaven
  module Transformer
    # Base for most of Shaven's transformers. Provides logic to deal with 
    # filling in contents, normalizing, etc. 
    class Content < Base
      # All tags with +id+ matching following pattern can be transformated.
      MATCHING_ID = /^rb\:(.+)/

      def can_be_transformed?
        node["id"].to_s =~ MATCHING_ID
      end

      def normalize!
        node['id'] = normalized_name
      end

      # Returns normalized item name, extended with scopes' names chain.  
      def normalized_name
        @normalized_name ||= begin
          # XXX: Optimize!
          #parts = scope.chain.map { |x| x.singularize }
          #parts.push(subst.shaven_item? ? subst.id : subst_name)
          #parts.join("_")
          subst_name#subst.shaven_item? ? subst.id : subst_name
        end
      end

      # Returns substitution object taken from current scope. 
      def subst
        @subst = scope[subst_name]
      end

      # Returns substitution object name extracted from id attribute.
      def subst_name
        @subst_name ||= node['id'].to_s.gsub(MATCHING_ID, '\\1')
      end

      # Returns final substitution value.
      def subst_value
        @subst_value ||= subst_call(subst.to_shaven, node)
      end

      # Helper for generating value from substitution object if this one
      # is callable. 
      def subst_call(subst, node)
        if subst.respond_to?(:call)
          args = subst.arity == 1 ? [node] : [] 
          subst.call(*args).to_shaven
        else
          subst
        end
      end

      # Generates combined scope from given two scopes. Each scope has to
      # be +Hash+, <tt>Shaven::Presenter</tt> or <tt>Shaven::Scope</tt> object.
      def combine_scope(main, sub, name=nil)
        sub.stringify_keys! if sub.is_a?(Hash)
        main.dup.unshift(sub, name)
      end
    end # Content
  end # Transformer
end # Shaven
