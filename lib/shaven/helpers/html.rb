module Shaven
  module Helpers
    module HTML
      # Generates document's element node with given attributes and content.
      #
      # ==== Example
      #
      #   tag(:h1, :id => "title") { "Hello world!" }
      #   tag(:p, :class => "description") { "Lorem ipsum dolor..." }
      #
      # produces:
      #
      #   <h1 id="title">Hello world!</h1>
      #   <p class="description">Lorem ipsum dolor...</p>
      #
      def tag(tag, attrs={}, &content)
        node = Nokogiri::XML::Node.new(name.to_s, @document)
        node.update!(attrs, &content)
      end

      # Shortcut for generating link node.
      #
      # ==== Example
      #
      #   a(:href => "/users", :id => "users_link") { "Users" }
      #   a(:href => "/users/1", :method => "delete", :remote => true, :confirm => "Are you sure?") { "Delete" }
      #
      # produces:
      #
      #   <a href="/users" id="users_link">Users</a>
      #   <a href="/users/1" data-method="delete" data-remote="data-remote" data-confirm="Are you sure?">Delete</a>
      #
      def a(attrs={}, &label)
        tag(:a, attrs, &label)
      end

      # Shortcut for generating image node.
      #
      # ==== Example
      #
      #   img(:src => "avatar.jpg" :class => "avatar")
      #   
      # produces:
      #
      #   <img src="avatar.jpg" class="avatar" />
      #
      def img(attrs={})
        tag(:img, attrs)
      end

      # Shortcut for generating div element node. 
      #
      # ==== Example
      #
      #   div(:id => "name") { "Marty Macfly" }
      #   div(:id => "email") { "marty@macfly.com" }
      #
      # produces:
      #
      #   <div id="name">Marty Macfly</div>
      #   <div id="email">marty@macfly.com</div>
      #
      def div(attrs={}, &content)
        tag(:div, attrs, &content)
      end
    end # HTML
  end # Helpers
end # Shaven
