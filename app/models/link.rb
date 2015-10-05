class Link < ActiveRecord::Base
  validates_presence_of :url
  belongs_to :user

  after_save do |link|
    UrlScrapperJob.perform_later link.id
  end

  def status
    read ? 'readed' : 'unreaded'
  end

  def description
    title ? title : url
  end
end
