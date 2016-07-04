class Recipe
  include HTTParty

  ENV["FOOD2FORK_KEY"] = 'f21f3da784df641f6c4a3f18233d6950'
  key_value = ENV['FOOD2FORK_KEY']
  hostport = ENV['FOOD2FORK_SERVER_AND_PORT'] || 'www.food2fork.com'
  base_uri "http://#{hostport}/api"
  default_params key: key_value
  format :json

  def self.for term
    get("/search", query: { q: term })["recipes"]
  end
end