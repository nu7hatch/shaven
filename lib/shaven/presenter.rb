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

    module Transformer
      class Base
        def self.can_be_transformed?(value)
          true
        end

        def self.find_value(scope, key)
          scope[key]
        end

        attr_reader :node, :name, :value, :scope
        
        def initialize(name, value, scope)
          @node, @name, @value, @scope = scope.node, name, value, scope
        end
        
        def can_continue?
          false
        end

        def transform!
          nil
        end
      end

      class Auto < Base
        def self.new(name, value, scope)
          if value.is_a?(::Array)
            List.new(name, value, scope)
          elsif value.is_a?(::Hash)
            Hash.new(name, value, scope)
          else
            TextOrNode.new(name, value, scope)
          end
        end
      end

      class Condition < Base
        def can_continue?
          !!value
        end

        def transform!
          node.remove unless value
          nil
        end
      end

      class ReverseCondition < Condition
        def can_continue?
          !value
        end

        def transform!
          node.remove if value
          nil
        end
      end

      class Hash < Base
        def self.can_be_transformed?(value)
          value.is_a?(::Hash)
        end

        def transform!
          value.stringify_keys
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
            new_node['rb'] = "__shaven_list_item_#{id}"
            parent.add_child(new_node)
            id += 1
          }

          node.remove
          array_scope = scope.dup.unshift(array_scope)
          Transformer.run!(array_scope.with(parent))
          
          nil
        end
      end

      class TextOrNode < Base
        def transform!
          if value.shaven_node?
            node.inner_html = value unless value === node
          else
            node.content = value.to_s
          end

          nil
        end
      end

      class Translation < Base
        def self.find_value(scope, key)
          nil
        end

        def self.needs_value?
          false
        end
      end

      CALLERS = [
        ['rb:if',     Condition],
        ['rb:unless', ReverseCondition],
        ['rb:t',      Translation],
        ['rb',        Auto]
      ]

      def self.run_each(scope, &block)
        CALLERS.each { |(name,trans)|
          if key = scope.node.delete(name)
            value = trans.find_value(scope, key)

            if trans.can_be_transformed?(value)
              transformer = trans.new(key, value, scope)
              extra_scope = transformer.transform!
              return extra_scope unless transformer.can_continue?
            end
          end
        }

        nil
      end

      def self.run!(scope)
        scope.node.children.each { |child|
          if child.elem?
            extra_scope = run_each(scope.with(child))
            scope.unshift(extra_scope) if extra_scope
            run!(scope)
            scope.shift if extra_scope
          end
        }
      end
    end

    def to_html
      Transformer.run!(Scope.new(self).with(@document.root))
      @document.to_html
    end

    # Some tricks to make presenter acts as array :)

    alias_method :key?, :respond_to?
    alias_method :[], :method
  end # Presenter
end # Shaven
