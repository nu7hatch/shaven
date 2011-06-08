require 'shaven/helpers/html'

module Shaven
  class Presenter
    include Helpers::HTML

    def self.feed(html)
      new(Document.new(html))
    end

    def initialize(document)
      @document = document
    end

    def to_html
      @document.to_html
    end
  end # Presenter
end # Shaven
