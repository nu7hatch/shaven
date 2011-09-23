require 'shaven/presenter'

module Shaven
  class Template    
    def initialize(html)
      @document = Document.new(html)
    end

    def render(context, locals={})
      unless compiled?
        context.feed(@document) if context.is_a?(Shaven::Presenter)
        Transformer.apply!(Scope.new(locals, context).with(@document.root))
        @compiled = true
      end
      @document.to_html
    end
    alias_method :to_html, :render

    def compiled?
      !!@compiled
    end
  end # Template
end # Shaven
