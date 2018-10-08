require 'HTTParty'
require 'Nokogiri'

class BpmScrapper
  def initialize(artist, track_name)
    @artist = artist.gsub(/ /, '+')
    @track_name = track_name.gsub(/ /, '+')
  end

  def that_page
    Nokogiri::HTML(HTTParty
            .get("https://www.beatport.com/search?q=#{@artist}+#{@track_name}"))
            .css('.standard-interior-tracks')
            .css('.bucket-items')
            .css('.buk-track-meta-parent')
            .css('.buk-track-title')[0]
            .children[1]
            .attributes['href']
            .value
  end

  def make_that_search
    Nokogiri::HTML(HTTParty.get("https://www.beatport.com/#{that_page}"))
  end

  def parse_that_bpm
    make_that_search.css('.interior-track-content')
                    .css('.interior-track-title-parent')
                    .css('.interior-track-content-list')
                    .css('.interior-track-content-item')
                    .css('.value')[2].children[0].to_s
  end
end

# Nokogiri::HTML(HTTParty.get('https://www.beatport.com/search?q=Jean+Jaques+Smoothie+Two+People+Original')).css('.standard-interior-tracks').css('.bucket-items').css('.buk-track-meta-parent').css('.buk-track-title')[0].children[1].attributes["href"].value
