# Fetches the URL and get the Title to update the Link
class UrlScrapperJob < ActiveJob::Base
  queue_as :default

  def perform(link_id)
    link = Link.find(link_id)
    response = HTTParty.get(link.url)
    page = Nokogiri::HTML(response.body, nil, 'UTF-8')
    title = page.search('title').inner_text
    logger.info "URL: #{link.url} Title: #{title}"
    description = page.xpath("//meta[case_insensitive_include(@name, 'description')
      or case_insensitive_include(@property, 'description')]/@content",
                             XpathFunctions.new).text
    link.update(title: title, description: description)
  end
end

# Allow to seach with insensitive case
class XpathFunctions
  def case_insensitive_include(node_set, str_to_match)
    node_set.find_all { |node| node.to_s.downcase.include? str_to_match.to_s.downcase }
  end
end
