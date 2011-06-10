# -*- coding: undecided -*-
require 'shaven/helpers/html'
require 'shaven/scope'
require 'shaven/document'
require 'shaven/item'
require 'shaven/transformer'

module Shaven
  class Presenter
    include Helpers::HTML

    class << self
      # Generates new presenter with assigned given html code.
      #
      # ==== Example
      #
      #    presenter = Preseneter.feed("<!DOCTYPE html><html><body>Foo!</body><html>")
      #    presenter.to_html # => ...
      #
      def feed(html)
        new(Document.new(html))
      end
    end

    def initialize(document)
      @document = document
    end

    module Transformers
      class Base
        def self.needs_value?
          true
        end

        def self.can_be_transformed?(value)
          true
        end

        def self.find_value(key, node, scope)
          scope.value_for(key, node)
        end

        attr_reader :node, :name, :value, :scope
        
        def initialize(node, name, value, scope)
          @node, @name, @value, @scope = node, name, value, scope
        end
        
        def can_continue?
          false
        end

        def transform!
        end
      end

      class Auto < Base
        def self.new(node, name, value, scope)
          if value.is_a?(::Array)
            List.new(node, name, value, scope)
          elsif value.is_a?(::Hash)
            Hash.new(node, name, value, scope)
          else
            TextOrNode.new(node, name, value, scope)
          end
        end
      end

      class Condition < Base
        def can_continue?
          !!value
        end

        def transform!
          node.remove unless value
        end
      end

      class ReverseCondition < Condition
        def can_continue?
          !value
        end

        def transform!
          node.remove if value
        end
      end

      class Hash < Base
        def self.can_be_transformed?(value)
          value.is_a?(::Hash)
        end

        def transform!
          @scope = scope.dup.unshift(value.stringify_keys)
        end
      end

      class List < Base
        def self.can_be_transformed?(value)
          value.respond_to?(:each)
        end

        def transform!
          array_scope = {}
          parent = node.parent
          id = 0

          value.each { |item|
            new_node = node.dup
            array_scope["__shaven_list_item_#{id}"] = item
            new_node['rb:with'] = "__shaven_list_item_#{id}"
            parent.add_child(new_node)
            id += 1
          }

          node.remove
          array_scope = scope.dup.unshift(array_scope)
          Shaven::Presenter.transform(parent, array_scope)
        end
      end

      class TextOrNode < Base
        def transform!
          if value.shaven_node?
            node.inner_html = value unless value === node
          else
            node.content = value.to_s
          end
        end
      end

      class Translation < Base
        def self.needs_value?
          false
        end
      end
    end

    class Directive
      DIRECTIVES = [
        ['rb:if',     Transformers::Condition],
        ['rb:unless', Transformers::ReverseCondition],
        ['rb:t',      Transformers::Translation],
        ['rb:with',   Transformers::Hash],
        ['rb:each',   Transformers::List],
        ['rb',        Transformers::Auto]
      ]

      def self.map(node, scope, &block)
        DIRECTIVES.map { |(name,trans)|
          if key = node[name] and !key.empty?
            value = trans.needs_value? ? trans.find_value(key, node, scope) : nil
            directive = new(key, value, trans)
            node.delete(name)
            yield directive
          end
        }
      end

      attr_reader :key
      attr_reader :value
      attr_reader :transformer

      def initialize(key, value, transformer)
        @key, @value, @transformer = key, value, transformer
      end
      
      def execute(node, scope)
        if @transformer.can_be_transformed?(value)
          exec = @transformer.new(node, key, value, scope)
          exec.transform!
          return exec
        end
      end
    end

    def self.transform(node, scope)
      node.children.each { |child|
        if child.elem?
          local_scope = nil
          
          Directive.map(child, scope) { |directive|
            if exec = directive.execute(child, scope)
              local_scope = exec.scope
              break unless exec.can_continue?
            end
          }
          
          transform(child, local_scope ? local_scope : scope)
        end
      }
    end

    def to_html
      #Transformer.transform(@document.root, Scope.new([self]))
      scope = Scope.new([self])
      self.class.transform(@document.root, scope)
      @document.to_html
    end

    # Some tricks to make presenter acts as array :)

    alias_method :key?, :respond_to?
    alias_method :[], :method
  end # Presenter
end # Shaven
