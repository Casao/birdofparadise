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
      details = get_details package
      resolver = Birdofparadise::Client::Resolver.new(details['name'], details['url'])
      resolver.info
    end

    def versions(package)
      details = get_details package
      resolver = Birdofparadise::Client::Resolver.new(details['name'], details['url'])
      resolver.versions
    end

    def lookup(package)
      get_details package
    end

    private

    def get_index
      @index ||= HTTParty.get(REGISTRY_URL).parsed_response
    end

    def get_details(package)
      package_url = REGISTRY_URL + "/#{package}"
      HTTParty.get(package_url).parsed_response
    end
  end
end
