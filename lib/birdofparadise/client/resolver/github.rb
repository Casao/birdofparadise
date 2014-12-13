require 'octokit'
require 'json'
require 'httparty'
require 'tempfile'

module Birdofparadise
  class Client
    class Resolver
      class Github
        
        def initialize(repo)
          @client = Octokit::Client.new
          @repo = repo
        end

        def info ref=nil
          options = {path: 'bower.json', headers: { accept: 'application/vnd.github.VERSION.raw'}}
          options[:ref] = ref unless ref.nil?
          JSON.parse(@client.contents(@repo, options))
        end

        def download ref=nil
          options = {}
          options[:ref] = ref unless ref.nil?
          url = Octokit.archive_link(@repo, options)
          temp = Tempfile.new(@repo.gsub(/\//, '_'))
          temp.write(HTTParty.get(url).parsed_response)
          temp
        end

        def versions
          @client.tags(@repo, per_page: 200).map { |t| t.name }
        end
      end
    end
  end
end
