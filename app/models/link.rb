class Link < ActiveRecord::Base
  include Taggable

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
    self.url = "http://#{url}" unless url.match %r{^http}
  end

  #
  # def description
  #   title ? title : url
  # end
end
