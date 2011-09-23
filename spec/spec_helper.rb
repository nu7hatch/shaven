require 'rspec'
require 'shaven'

RSpec.configure do |conf|
  conf.mock_with :mocha
end

def render(file, presenter=Shaven::Presenter)
  html = File.read(File.expand_path("../fixtures/#{file}", __FILE__))
  Shaven::Template.new(html).to_html(presenter.new)
end
