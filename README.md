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
      <title rb="title">Example title!</title>
    </head>
    <body>
      <h1 rb="title">Example title</h1>
      <p rb="description">Example description...</p>
    </body>
    </html>
    HTML

    SimplePresenter.feed(html).to_html

This code produces following html:

    <!DOCTYPE html>
    <html>
    <head>
      <title rb="title">Hello World!</title>
    </head>
    <body>
      <h1 rb="title">Hello World!</h1>
      <p rb="description">Yeah, hello beautiful code...</p>
    </body>
    </html>
