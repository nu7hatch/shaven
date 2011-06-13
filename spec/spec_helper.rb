require 'rspec'
require 'shaven'

RSpec.configure do |conf|
  conf.mock_with :mocha
end

def make_presenter(file, presenter=Shaven::Presenter)
  html = File.read(File.expand_path("../fixtures/#{file}", __FILE__))
  presenter.feed(html)
end
