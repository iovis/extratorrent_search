require 'cgi'
require 'httparty'

module ExtratorrentSearch
  ##
  # Object that contains the info for a torrent file
  class Link
    attr_reader :filename, :size, :magnet_link, :seeders, :leechers

    def initialize(filename: nil, size: nil, magnet_link: nil, seeders: nil, leechers: nil)
      @filename = filename
      @size = size
      @magnet_link = magnet_link
      @seeders = seeders
      @leechers = leechers
    end

    def <=>(other)
      @seeders <=> other.seeders
    end

    def to_s
      "#{@filename} (#{@size}) - [#{@seeders.green}/#{@leechers.red}]"
    end

    def info_hash
      @info_hash ||= extract_hash
    end

    private

    def extract_hash
      # Extract magnet properties to a Hash and then parse the sha1 info hash
      raw_hash = magnet_link[/(xt.*?)&/, 1]  # extract the xt property
      raw_hash.split(':').last.downcase
    end
  end
end
