require "nokogiri"

module Shaven
  unless {}.respond_to?(:stringify_keys)
    require 'shaven/core_ext/hash'
  end

  require 'shaven/core_ext/object'
  require 'shaven/nokogiri_ext/node'
  require 'shaven/presenter'
  require 'shaven/version'

  if defined?(Rails)
    require 'shaven/railtie'
  end

  class << self
    # You can specify what caller attribute names should be used in your 
    # templates to define transformations. By default <tt>rb</tt>/<tt>rb:*</tt>
    # attributes are in use. 
    attr_writer :caller_key
    
    def caller_key
      @template_key ||= 'rb'
    end
  end # self
end # Shaven
