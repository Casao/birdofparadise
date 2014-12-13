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

    def info(package)
      @client ||= Birdofparadise::Client.new
      results = @client.info package
      versions = @client.versions package
      puts JSON.pretty_generate(results)
      puts "\nAvailable versions:"
      versions.each do |version|
        puts "\t- #{version}"
      end
    end

    def lookup(package)
      @client ||= Birdofparadise::Client.new
      results = @client.lookup package
      puts "#{results['name']} #{results['url']}"
    end
  end
end
