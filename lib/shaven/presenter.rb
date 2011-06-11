require 'shaven/scope'
require 'shaven/document'
require 'shaven/transformer'
require 'shaven/helpers/html'

module Shaven
  # Presenters are placeholder for all logic which is going to fill in your html 
  # templates. Remember that presenters shouldn't contain any raw HTML code, 
  # you can generate it using html helpers (see <tt>Shaven::Helpers::HTML</tt>
  # for details).
  #
  # ==== Simple example
  #
  #   class DummyPreseneter < Shaven::Presenter
  #     def title
  #       "Hello world!"
  #     end
  #   end
  #
  #   presenter = DummyPreseneter.feed("<!DOCTYPE html><html><body><h1 rb="title">Example...</h1></body><html>")
  #   presenter.to_html # => ...
  #
  # ==== DOM Manipulation
  #
  # If your presenter method has one argument, then related DOM node will be passed
  # to it while transformation process. You can use it to change its attributes or
  # content, replace it with other node or text, remove it, etc.
  #
  #   class DummyPresenter < Shaven::Presenter
  #     def title(node)
  #       node.update!(:id => "title") { "Hello world!" }
  #     end
  #   end
  #
  # ==== HTML helpers
  # 
  # Shaven's presenters provides set of helpers to generate extra html nodes. Take a look
  # at example:
  #
  #   class DummyPresenter < Shaven::Presenter
  #     def login_link
  #       a(:href => login_path) { "Login to your account!" }
  #     end
  #
  #     def title
  #       tag(:h1, :id => "title") { "Hello world!" }
  #     end
  #   end
  #
  class Presenter
    include Helpers::HTML

    class << self
      # Generates new presenter with assigned given html code.
      def feed(html)
        new(Document.new(html))
      end
    end

    def initialize(document)
      @document = document
    end

    def to_html
      Transformer.apply!(Scope.new(self).with(@document.root))
      @document.to_html
    end

    # Some tricks to make presenter acts as array :)

    alias_method :key?, :respond_to?
    alias_method :[], :method
  end # Presenter
end # Shaven
