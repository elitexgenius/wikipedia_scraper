require 'open-uri'
require 'nokogiri'

class PagesController < ApplicationController
  def index
    @errors = []
    @data = []
  end

  def scrape
    url = params[:wikipedia_link]
    @errors = []

    if url.present?
      if valid_wikipedia_link?(url)
        @data = scrape_wikipedia_page(url)
      else
        @errors << 'Invalid Wikipedia link'
      end
    else
      @errors << 'Please enter a Wikipedia link'
    end

    render :index
  end

  private

  def valid_wikipedia_link?(url)
    url =~ %r{\Ahttps?://(www\.)?en\.wikipedia\.org/wiki/}i
  end

  def scrape_wikipedia_page(url)
    page = Nokogiri::HTML(URI.open(url))

    title = page.css('#firstHeading').text.strip
    languages = page.css('.interlanguage-link-target').map { |lang| lang.text.strip }

    { title: title, languages: languages }
  end
end
