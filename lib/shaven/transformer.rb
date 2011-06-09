module Shaven
  module Transformer
    # This chain contains list of transformers which will be sequentially applied to
    # each node in your template. Order is important because some of transformers
    # allow to keep going with other transformations after they are applied. 
    CHAIN = []

    require 'shaven/transformers/dummy'
    require 'shaven/transformers/list'
    require 'shaven/transformers/scopeable'
    require 'shaven/transformers/replaceable'
    require 'shaven/transformers/text_or_node'
    require 'shaven/transformers/conditional'
    
    CHAIN.concat([Dummy, Conditional, List, Scopeable, Replaceable, TextOrNode])

    # Syntactic sugar for <tt>Shaven::Transformer::Base.transform_children</tt>.
    # Check it out for more details. 
    def self.transform(node, scope)
      Base.transform_children(node, scope)
    end
  end # Transformer
end # Shaven
