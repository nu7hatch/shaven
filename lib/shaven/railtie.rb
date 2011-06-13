require 'action_view'
require 'active_support'
require 'shaven'

module Shaven
  module Rails
    module Presenter
      def method_missing(method, *args, &block)
        if respond_to?(method)
          @_view.send(method, *args, &block)
        else
          super
        end
      end

      def respond_to?(method)
        super || @_view.respond_to?(method)
      end
    end # Presenter

    class TemplateHandler < ActionView::Template::Handler
      include ActionView::Template::Handlers::Compilable

      class_attribute :default_format
      self.default_format = Mime::HTML
      
      def compile(template)
        presenter_klass = presenter_class_for_template(template)

        <<-SHAVEN
          presenter = #{presenter_klass}.feed(#{template.source.inspect})

          variables = controller.instance_variable_names
          variables -= %w[template]
        
          variables.each { |name| 
            presenter.instance_variable_set(name, controller.instance_variable_get(name))
          }

          presenter.instance_variable_set('@_view', self)
          presenter.to_html(local_assigns.merge(:yield => content_for(:layout)))
        SHAVEN
      end

      private

      def presenter_class_for_template(template)
        const_name = (template.virtual_path.to_s+"_presenter").camelize
        defined?(const_name) ? const_name.constantize : Shaven::Presenter
      end
    end # TemplateHandler
  end # Rails

  class Presenter
    include Rails::Presenter
  end # Presenter

  class Railtie < ::Rails::Railtie
    initializer "shaven.configure_rails_initialization" do |app|
      ActiveSupport::Dependencies.autoload_paths << ::Rails.root.join('app/presenters')
      ActionView::Template.register_template_handler(:html, Shaven::Rails::TemplateHandler)
    end
  end
end # Shaven
