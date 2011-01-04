require 'rubygems'
require 'sinatra'
require 'mongoid'

# MongoDB configuration
Mongoid.configure do |config|
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    uri = URI.parse(ENV['MONGOHQ_URL'])
    config.master = conn.db(uri.path.gsub(/^\//, ''))
  else
    config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('test')
  end
end

# Models
class Counter
    include Mongoid::Document
    
    field :count, :type => Integer
    
    def self.increment
      c = first || new({:count => 0})
      c.inc(:count, 1)
      c.save
      c.count
    end
end

# Controllers
get '/' do
  "Hello visitor nº" + Counter.increment.to_s
end

