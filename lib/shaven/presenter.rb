require 'shaven/helpers/html'

module Shaven
  class Presenter
    include Helpers::HTML

    class << self
      def feed(html)
        new(Document.new(html))
      end
    end

    def initialize(document)
      @document = document
    end

    def to_html
      fill_in!(@document.root)
      @document.to_html
    end

    private

    def fill_in!(node)
      node.children.each { |child|
        child.replace(fill_in_node(child)) if child['rb']
        fill_in!(child)
      }
    end

    def fill_in_node(node)
      origin  = Tag.cast(node)
      entry = method(origin.delete('rb').to_s.to_sym)
      data  = entry.arity == 1 ? entry.call(origin) : entry.call
      
      if data.is_a?(Tag) and (data.replacement? or data === origin)
        data
      else
        origin.update! { data }
      end
    end
  end # Presenter
end # Shaven
