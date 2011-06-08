require 'shaven/helpers/html'
require 'shaven/transformer'

module Shaven
  class Presenter
    class Scope < Array
      def [](key)
        each { |layer| return layer[key] if layer.key?(key) }
      end
    end

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
      Transformer.transform(@document.root, Scope.new([self]))
      @document.to_html
    end

    alias_method :key?, :respond_to?
    alias_method :[], :method
  end # Presenter
end # Shaven
