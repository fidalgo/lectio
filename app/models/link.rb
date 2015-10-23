class Link < ActiveRecord::Base
  validates_presence_of :url
  belongs_to :user
  paginates_per 16

  before_save :add_scheme_to_url

  # after_save do |link|
  #   UrlScrapperJob.perform_later link.id
  # end

  def status
    read ? 'readed' : 'unreaded'
  end

  protected

  def add_scheme_to_url
    unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
      self.url = "http://#{self.url}"
    end
  end

  #
  # def description
  #   title ? title : url
  # end
end
