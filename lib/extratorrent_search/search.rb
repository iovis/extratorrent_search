require 'erb'
require 'open-uri'
require 'nokogiri'
require 'yaml'

module ExtratorrentSearch
  ##
  # Extract a list of results from your search
  # ExtratorrentSearch::Search.new("Suits s05e16")
  class Search
    NUMBER_OF_LINKS = 5
    BASE_URL = 'https://extratorrent.cc'.freeze

    attr_accessor :url

    def initialize(search)
      # Order by seeds desc
      @url = "#{BASE_URL}/search/?search=#{ERB::Util.url_encode(search)}&srt=seeds&order=desc"
    end

    def results_found?
      @results_found ||= page.at('i:contains("No torrents")').nil?
    rescue OpenURI::HTTPError
      @results_found = false
    end

    def links
      @links ||= generate_links
    end

    private

    def page
      @page ||= Nokogiri::HTML(open(@url))
    end

    def crawl_link(link)
      Link.new(
        filename: link.at('.tli > a').text,
        size: link.css('td')[4].text,
        magnet_link: link.at('a[title="Magnet link"]')['href'],
        seeders: link.at('td.sy, td.sn').text,
        leechers: link.at('td.ly, td.ln').text
      )
    end

    def generate_links
      links = []
      return links unless results_found?

      link_nodes = page.css('tr.tlr, tr.tlz')
      link_nodes.each { |link| links << crawl_link(link) }

      links.first(NUMBER_OF_LINKS)
    end
  end
end
