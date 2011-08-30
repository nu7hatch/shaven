# Shaven - Templating without mustaches!

Hey guys, look at present fasion... mustaches are not fashionable anymore =P.
Take a look how nice looking are shaven templates.

## Motivation

I'm not a designer, usualy all templates in my work are prepared by external
design studios or freelancers... But of course they are always pure xhtml.
So still we have to deal with them, convert to haml, fill in with mustaches or
erb sh**t! Now, my patience is over. Shaven will readmit some MVPC's fresh
air to your web apps and allow you to get rid of stupid logic from your views. 

## Installation

Installation with rubygems should go without quirks. Shaven depends on Nokogiri - if
you don't have it installed yet then i recommend you to check out its documentation
to avoid problems.

    $ gem install shaven

## How it works?

Shaven views are splited into two layers (similar to defunk's mustache) - Template
and Presenter. Templates are pure html files, Presenters are ruby classes
which provides data for templates. Depending on the data type provided by
presenter's methods you can freely and easily manipulate all contents within
your templates. Ok, lets finish talking and take a look at examples...

### Simple usage

    class SimplePresenter < Shaven::Presenter
      def title
      	"Hello world!"
      end

      def description
        "Yeah, hello beautiful code..."
      end
    end

    html = <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
      <title data-fill="title">Example title!</title>
    </head>
    <body>
      <h1 data-fill="title">Example title</h1>
      <p data-fill="description">Example description...</p>
    </body>
    </html>
    HTML

    SimplePresenter.feed(html).to_html

This code produces following html:

    <!DOCTYPE html>
    <html>
    <head>
      <title>Hello World!</title>
    </head>
    <body>
      <h1>Hello World!</h1>
      <p>Yeah, hello beautiful code...</p>
    </body>
    </html>

### DOM manipulation

    class ManipulationPresenter < Shaven::Presenter
      # If you add parameter to the presenter method, original node will
      # passed to it. Given element is an Nokogiri::XML::Node with some
      # extra helpers for content manipulation. 
      def login_link(node)
        node.update!(:href => logout_path, :method => "delete")
      end

      # You can use extra html helpers to create new dom elements...
      def home_page_link
        a(:href => root_path, :class => "home-page-link") { "Go home!" }
      end
 
      # ... or to replace current.
      def title(node)
        node.replace! { tag(:h1, :id => "header") { "This is Sparta! "} }
      end
    end

    html = <<-HTML
    <!DOCTYPE html>
    <html>
    <body>
      <div rb="title">Example title</div>
      <a href="#" data-fill="logout_link">Logout!</a>
      <div data-fill="home_page_link">Home page link will go here...</div>
    </body>
    </html>
    HTML

    ManipulationPresenter.feed(html).to_html

Result:

    <!DOCTYPE html>
    <html>
    <body>
      <h1 id="header">This is Sparta!</h1>
      <a href="/logout" data-method="delete">Logout!</a>
      <div><a href="/" class="home-page-link">Go Home!</a></div>
    </body>
    </html>
    
### Hash scopes and lists

Now, the true power of Shaven. Suport for lists and scopes.

    class ComplexPresenter < Shaven::Presenter
      # As scopes are treaded all hashes and objects responding to `#to_shaven`
      # method (which returns hash with attributes).
      def user
        { :name => "John Doe",
          :email => "john@doe.com",
        }
      end

      def users_list
        [ { :name => tag(:strong) { "Emmet Brown" }, :email => "emmet@brown.com"},
          { :name => proc { |node| node.update!(:class => "marty") { "Marty Macfly" }, :email => "marty@macfly.com" },
          { :name => "Biff Tannen", :email => "biff@tannen.com" }
        ]
      end
    end

    html = <<-HTML
    <!DOCTYPE html>
    <html>
    <body>
      <h1>Single user here!</h1>
      <div data-fill="user">
        <h2 data-fill="name">Sample name</h2>
        <p data-fill="email">sapmle@email.com</p>
      </div>
      <h1>More users</h1>
      <ul id="users">
        <li data-fill="users_list">
          <span data-fill="name">Sample name</span>
          <span data-fill="email">sample@email.com</span>
        <li>
      </ul>
    </body>
    </html>
    HTML

And the awesome result is:

    <!DOCTYPE html>
    <html>
    <body>
      <h1>Single user here!</h1>
      <div data-fill="user">
        <h2>Adam Smith</h2>
        <p>adam@smith.com</p>
      </div>
      <h1>More users</h1>
      <ul id="users">
        <li>
          <span><strong>Emmet Brown</strong></span>
          <span>brown@brown.com</span>
        <li>
        <li class="marty">
          <span>Marty Macfly</span>
          <span>marty@macfly.com</span>
        <li>
        <li>
          <span>Biff Tannen</span>
          <span>biff@tannen.com</span>
        <li>
      </ul>
    </body>
    </html>

### Conditionals

    class ConditionalsPresenter < Shaven::Presenter
      def true?
        true
      end

      def false?
        false
      end
    end

    html = <<-HTML
    <!DOCTYPE html>
    <html>
    <body>
      <div data-if="true?">Hello...</div>
      <div data-unless="false?">World!</div>
    </body>
    </html>
    HTML

### Dummy elements

    html = <<-HTML
    <!DOCTYPE html>
    <html>
    <body>
      <h1>Hello dummies!</h1>
      <div data-dummy="yes">This is dummy text!</div>
    </body>
    </html>
    HTML
    
produces:

    <!DOCTYPE html>
    <html>
    <body>
      <h1>Hello dummies!</h1>
    </body>
    </html>    

## Benchmarks

Ruby 1.9.2

          user     system      total        real
    Shaven    3.480000   0.050000   3.530000 (  3.539728)
    ERB       1.360000   0.010000   1.370000 (  1.374822)
    Mustache  6.830000   0.080000   6.910000 (  6.904736)
    HAML     10.800000   0.080000  10.880000 ( 10.886872)

Ruby 1.8.7

          user     system      total        real
    Shaven    8.510000   0.120000   8.630000 (  8.658850)
    ERB       1.510000   0.010000   1.520000 (  1.516075)
    Mustache  5.230000   0.070000   5.300000 (  5.314266)
    HAML     13.100000   0.230000  13.330000 ( 13.337038)
