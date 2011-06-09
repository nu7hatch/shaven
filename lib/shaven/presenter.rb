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

    def to_html
      Transformer.transform(@document.root, Scope.new([self]))
      @document.to_html
    end

    # Some tricks to make presenter acts as array :)

    alias_method :key?, :respond_to?
    alias_method :[], :method
  end # Presenter
end # Shaven
