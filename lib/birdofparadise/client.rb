require 'httparty'
module Birdofparadise
  class Client
    REGISTRY_URL = "http://bower.herokuapp.com/packages"
    attr_reader :index

    def get_index
      @index ||= HTTParty.get(REGISTRY_URL).parsed_response
    end

    def search(query)
      get_index if @index.nil?
      @index.find_all { |package| package["name"].match query }
    end
  end
end
