# Fetches the URL and get the Title to update the Link
class UrlScrapperJob < ActiveJob::Base
  queue_as :url_scrapper
  REDIRECT_LIMIT = 10

  def perform(link_id)
    @link = Link.find_by_id(link_id)
    process unless @link.nil?
  end

  private

  def process
    url = @link.url =~ /^http/ ? @link.url : "http://#{@link.url}"
    @uri = URI.parse url
    handle_headers
  end

  def handle_headers
    headers = fetch_headers
    case headers.content_type
    when /application/
      handle_application
    else
      handle_html
    end
  end

  def handle_application
    filename = File.basename(@uri.path)
    @link.update title: filename
  end

  def handle_html
    response = fetch_page
    page = Nokogiri::HTML(response)
    @link.update title: page_title(page), description: page_description(page)
  end

  def page_description(page)
    # Since there are sites with more than one description (ex. the opengraph )
    # properties whe get the first one.
    descriptions = page.xpath("//meta[case_insensitive_include(@name, 'description')
      or case_insensitive_include(@property, 'description')]/@content",
                              XpathFunctions.new)
    page_description = ''
    descriptions.each do |description|
      next unless !description.nil? && description.text.valid_encoding?
      page_description = description.text if description.text.length > page_description.length
    end
    return page_description.strip unless page_description.blank?
  end

  def page_title(page)
    title = page.search('title').inner_text
    return title if title.valid_encoding? && !title.blank?
  end

  def fetch_headers(limit = REDIRECT_LIMIT)
    # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true if @uri.scheme == 'https'
    request_uri = @uri.request_uri.nil? ? '/' : @uri.request_uri
    http.request_head(request_uri) do |response|
      case response
      when Net::HTTPSuccess then
        return response
      when Net::HTTPRedirection then
        location = response['location']
        parsed_location = URI.parse location
        @uri = parsed_location.absolute? ? parsed_location : @uri.merge(parsed_location)
        return fetch_headers(limit - 1)
      when Net::HTTPMethodNotAllowed then
        return response
      else
        return response.value
      end
    end
  end

  def fetch_page(limit = REDIRECT_LIMIT)
    # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true if @uri.scheme == 'https'
    request_uri = @uri.request_uri.nil? ? '/' : @uri.request_uri
    http.request_get(request_uri) do |response|
      case response
      when Net::HTTPSuccess then
        return response.body
      when Net::HTTPRedirection then
        location = response['location']
        parsed_location = URI.parse location
        @uri = parsed_location.absolute? ? parsed_location : @uri.merge(parsed_location)
        return fetch_page(limit - 1)
      else
        return response.value
      end
    end
  end

  # Allow to seach with insensitive case
  class XpathFunctions
    def case_insensitive_include(node_set, str_to_match)
      node_set.find_all { |node| node.to_s.downcase.include? str_to_match.to_s.downcase }
    end
  end
end
