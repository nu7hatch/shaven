require "nokogiri"

module Shaven
  unless {}.respond_to?(:stringify_keys)
    require 'shaven/core_ext/hash'
  end

  require 'shaven/core_ext/object'
  require 'shaven/nokogiri_ext/node'
  require 'shaven/presenter'
  require 'shaven/version'

  #if defined?(Rails)
  #  require 'shaven/railtie'
  #end

  # You can specify what caller attribute names should be used in your 
  # templates to define transformations. By default the html5 <tt>data-</tt>
  # attributes are in use. 
  def self.caller_key_prefix=(key)
    @caller_key = key
  end
    
  def self.caller_key_prefix
    @caller_key ||= 'data-'
  end
end # Shaven
