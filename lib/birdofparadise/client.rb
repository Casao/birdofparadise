require_relative 'client/resolver'
require 'httparty'
module Birdofparadise
  class Client
    REGISTRY_URL = "http://bower.herokuapp.com/packages"
    attr_reader :index

    def search(query)
      get_index if @index.nil?
      @index.find_all { |package| package["name"].match query }
    end

    def info(package)
      package_url = REGISTRY_URL + "/#{package}"
      details = HTTParty.get(package_url).parsed_response
      resolver = Birdofparadise::Client::Resolver.new(details['name'], details['url'])
      resolver.info
    end

    def versions(package)
      package_url = REGISTRY_URL + "/#{package}"
      details = HTTParty.get(package_url).parsed_response
      resolver = Birdofparadise::Client::Resolver.new(details['name'], details['url'])
      resolver.versions
    end

    private

    def get_index
      @index ||= HTTParty.get(REGISTRY_URL).parsed_response
    end
  end
end
