require 'octokit'
require 'json'

module Birdofparadise
  module Client
    module Resolver
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

        def install ref=nil

        end

        def versions
          @client.tags(@repo, per_page: 200).map { |t| t.name }
        end
      end
    end
  end
end
