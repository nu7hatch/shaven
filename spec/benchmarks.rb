$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require 'benchmark'

require 'shaven'
require 'erb'
require 'haml'
require 'mustache'

$erb = <<-HTML
<!DOCTYPE html>
<html>
<head>
  <title><%= @title %></div>
</head>
<body>
  <% if @condition %>
    Something conditional!
  <% else %>
    Something else
  <% end %>

  <div id="user">
    <div class="name"><%= @user[:name] %></div>
    <div class="email"><%= @user[:email] %></div>
  </div>

  <ul id="items">
    <% @items.each do |item| %>
      <li class="item">
        <div class="name"><%= item[:name] %></div>
        <div class="price"><%= item[:price] %></div>
      </li>
    <% end %>
  </ul>
</body>
</html>
HTML

$mustache = <<-HTML
<!DOCTYPE html>
<html>
<head>
  <title>{{title}}</div>
</head>
<body>
  {{#condition}}
    Something conditional!
  {{/condition}}
  {{^condition}}
    Something else
  {{/condition}}

  {{#user}}
  <div id="user">
    <div class="user">{{name}}</div>
    <div class="email">{{email}}</div>
  </div>
  {{/user}}

  <ul id="items">
    {{#items}}
      <li class="item">
        <div class="name">{{name}}</div>
        <div class="price">{{price}}</div>
      </li>
    {{/items}}
  </ul>
</body>
</html>
HTML

$haml = <<-HAML
!!!
%html
  %head
    %title= title
  %body
    - if condition
      Something conditional!
    - else
      Something else
    #user
      .name= user[:name]
      .email= user[:email]
    %ul#items
      - items.each do |item|
        %li.item
          .name= item[:name]
          .price= item[:price]
HAML

$doc = <<-HTML
<!DOCTYPE html>
<html>
<head>
  <title data-fill="page_title">Sample title</title>
</head>
<body>
  <div data-if="condition">
    Something conditional!
  </div>
  <div data-unless="condition">
    Something else
  </div>

  <div data-fill="user">
    <div data-fill="name">Name</div>
    <div data-fill="email">email@mail.com</div>
  </div>

  <ul id="items">
    <li data-fill="items">
      <div data-fill="name">Foobar</div>
      <div data-fill="price">$250</div>
    </li>
  </ul>
</body>
</html>
HTML

$user = { 
  :name => "Marty Macfly", 
  :email => "marty@macfly.com" 
}

$items = [
  { :name => "First", :price => "$250" },
  { :name => "Second", :price => "$300" },
  { :name => "Third", :price => "$500" }
]

$title = "Hello world!"

class MyPresenter < Shaven::Presenter
  def user
    $user
  end

  def items
    $items
  end

  def condition
    false
  end

  def page_title
    $title
  end
end

class ErbView
  def initialize
    @condition = false
    @title = $title
    @items = $items
    @user = $user
  end

  def render
    ERB.new($erb).result(binding)
  end
end

def render_shaven
  Shaven::Template.new($doc).to_html(MyPresenter.new)
end

def render_erb
  ErbView.new.render
end

def render_haml
  Haml::Engine.new($haml).render(self, { :user => $user, :items => $items, :title => $title, :condition => false})
end

def render_mustache
  Mustache.render($mustache, { :user => $user, :items => $items, :title => $title, :condition => false})
end

n = 3000

Benchmark.bm do |x|
  x.report("Shaven  ") { n.times { render_shaven } }
  x.report("ERB     ") { n.times { render_erb } }
  x.report("Mustache") { n.times { render_mustache } }
  x.report("HAML    ") { n.times { render_haml } }
end
