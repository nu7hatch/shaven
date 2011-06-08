require 'nokogiri'

module Shaven
  class Document < Nokogiri::HTML::Document
    def self.new(thing, encoding=nil, &block)
      Nokogiri::HTML::Document.parse(thing, nil, encoding, Nokogiri::XML::ParseOptions::DEFAULT_HTML, &block)
    end
  end # Document
end # Shaven
