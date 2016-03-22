# Fetches the URL and get the Title to update the Link
class UrlScrapperJob < ActiveJob::Base
  queue_as :default

  def perform(link_id)
    link = Link.find(link_id)
    url = link.url =~ /^http/ ? link.url : "http://#{link.url}"
    # TODO: handle exceptions retrying with the www
    response = HTTParty.get(url)
    page = Nokogiri::HTML(response.body)
    link.update title: page_title(page), description: page_description(page)
  end

  def page_description(page)
    # Since there are sites with more than one description (ex. the opengraph )
    # properties whe get the first one.
    descriptions = page.xpath("//meta[case_insensitive_include(@name, 'description')
      or case_insensitive_include(@property, 'description')]/@content",
                              XpathFunctions.new)
    descriptions.each do |description|
      if !description.nil? && description.text.valid_encoding?
        return description.text
      end
    end
  end

  def page_title(page)
    title = page.search('title').inner_text
    return title if title.valid_encoding? && !title.blank?
  end

  # Allow to seach with insensitive case
  class XpathFunctions
    def case_insensitive_include(node_set, str_to_match)
      node_set.find_all { |node| node.to_s.downcase.include? str_to_match.to_s.downcase }
    end
  end
end
