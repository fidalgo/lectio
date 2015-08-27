# Fetches the URL and get the Title to update the Link
class UrlScrapperJob < ActiveJob::Base
  queue_as :default

  def perform(link)
    page = Nokogiri::HTML(open(link.url))
    title = page.css('title').text
    link.update(title: title)
  end
end
