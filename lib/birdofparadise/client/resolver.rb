require_relative './resolver/github.rb'
require_relative '../config.rb'
require 'forwardable'
require 'disk_store'
require 'rubygems/package'
require 'zlib'

module Birdofparadise
  class Client
    class Resolver
      extend Forwardable

      def_delegators :@resolver, :info, :versions

      def initialize(name, repo)
        @name = name
        @repo = repo
        @resolver = determine_resolver(repo)
        @cache = DiskStore.new('cache')
      end

      def install(version=nil)
        file = download(version)
        tgz = Zlib::GzipReader.new file
        extract_tgz tgz
      end

      def download(version=nil)
        file = @cache.fetch(cache_key(version)) do
          @resolver.download(version)
        end
        file.rewind
        file
      end

      def dependencies
        Array(info['dependencies'])
      end

      private

      def cache_key(version=nil)
        name = "#{@name}"
        name += "-#{version}" unless version.nil?
        name
      end

      def determine_resolver(repo)
        case repo
          when /^git:\/\/github\.com\/(?<repo>[\w\/]+)\.git$/
            repo = Regexp.last_match[:repo]
            Birdofparadise::Client::Resolver::Github.new(repo)
        end
      end

      def extract_tgz(file)
        destination = Birdofparadise::Config.path
        Gem::Package::TarReader.new(file) do |tar|
          dest = nil
          top = nil
          first = true
          tar.each do |entry|
            if entry.full_name == '././@LongLink'
              next
            end
            dest ||= File.join destination, entry.full_name
            if entry.directory?
              top = entry.full_name if first
              first = false if first
              FileUtils.rm_rf dest unless File.directory? dest
              FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
            elsif entry.file?
              FileUtils.rm_rf dest unless File.file? dest
              File.open dest, "wb" do |f|
                f.print entry.read
              end
              FileUtils.chmod entry.header.mode, dest, :verbose => false
            elsif entry.header.typeflag == '2' #Symlink!
              File.symlink entry.header.linkname, dest
            end
            dest = nil
          end
          src = File.join destination, top
          dest = File.join destination, @name
          FileUtils.mv src, dest
        end
      end
    end
  end
end
