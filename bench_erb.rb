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
    <title rb="page_title">Sample title</title>
  </head>
<body>
  <div rb:if="condition">
    Something conditional!
  </div>
  <div rb:unless="condition">
    Something else
  </div>

  <div rb="user">
    <div rb="name">Name</div>
    <div rb="email">email@mail.com</div>
  </div>

  <ul id="items">
    <li rb="items">
      <div rb="name">Foobar</div>
      <div rb="price">$250</div>
    </li>
  </ul>
</body>
</html>
HTML

$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))

require 'rubygems'
require 'isolate/now'
require 'shaven'
require 'erb'
require 'haml'
require 'mustache'
require 'benchmark'

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
  MyPresenter.feed($doc).to_html
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

n = 2000

Benchmark.bm do |x|
  x.report("Shaven  ") { n.times { render_shaven } }
  x.report("Mustache") { n.times { render_mustache } }
  x.report("ERB     ") { n.times { render_erb } }
  x.report("HAML    ") { n.times { render_haml } }
end
