module Shaven
  class Document < Nokogiri::HTML::Document
    class << self
      def new(thing, encoding=nil, &block)
        parse(thing, nil, encoding, Nokogiri::XML::ParseOptions::DEFAULT_HTML, &block)
      end
    end # self
  end # Document
end # Shaven
