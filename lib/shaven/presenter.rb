require 'shaven/helpers/html'

module Shaven
  class Presenter
    include Helpers::HTML

    def initialize(document)
      @document = document
    end
  end # Presenter
end # Shaven
