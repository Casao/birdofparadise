require_relative 'client'
module Birdofparadise
  class CLI
    def search(query)
      @client ||= Birdofparadise::Client.new
      results = @client.search query
      results.each do |result|
        puts "\t#{result["name"]} #{result["url"]}"
      end
    end
  end
end
