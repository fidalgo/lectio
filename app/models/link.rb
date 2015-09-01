class Link < ActiveRecord::Base
  validates_presence_of :url

  belongs_to :user

  def status
    read ? 'readed' : 'unreaded'
  end

  def description
    title ? title : url
  end
end
