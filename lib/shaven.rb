require "nokogiri"

unless {}.respond_to?(:stringify_keys)
  require 'shaven/core_ext/hash'
end

require 'shaven/core_ext/object'
require 'shaven/nokogiri_ext/node'
require 'shaven/presenter'

module Shaven
end
