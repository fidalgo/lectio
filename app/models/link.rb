class Link < ActiveRecord::Base

  validates_presence_of :url

  belongs_to :user

  def status
    self.read ? 'readed' : 'unreaded'
  end

end
