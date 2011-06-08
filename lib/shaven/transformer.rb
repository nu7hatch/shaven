module Shaven
  module Transformer
    CHAIN = []

    require 'shaven/transformers/base'
    require 'shaven/transformers/list'
    require 'shaven/transformers/scopeable'
    require 'shaven/transformers/replaceable'
    require 'shaven/transformers/text_or_node'
    
    CHAIN.concat([List, Scopeable, Replaceable, TextOrNode])

    def self.transform(node, scope)
      Base.transform_all(node, scope)
    end
  end # Transformer
end # Shaven
