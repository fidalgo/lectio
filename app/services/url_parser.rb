require 'open-uri'
require 'nokogiri'

class URLParser

  def initialize(url)
    @url = url
  end

  def update_title
    page = Nokogiri::HTML(open(@url))
    title = page.css('title').text
    Link.where(url: @url).update_all(title: title)
  end

end
