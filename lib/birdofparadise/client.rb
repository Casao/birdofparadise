require 'tempfile'
require 'minigit'

module Birdofparadise
    class Client
        def get_repo url, ref=:master
            temp_file = Tempfile.new('url')
            archive = MiniGit.archive({format: :tar, remote: url}, ref)
            temp_file.write(archive)
        end
    end
end