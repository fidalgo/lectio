class Link < ActiveRecord::Base
  include Taggable

  validates_presence_of :url, :user
  validates_inclusion_of :read, in: [true, false]
  belongs_to :user, required: true
  paginates_per 16

  before_save :add_scheme_to_url

  # TODO: this will be moved to i18n later
  def status
    read ? 'readed' : 'unreaded'
  end

  protected

  def add_scheme_to_url
    self.url = "http://#{url}" unless url.match(/^http/)
  end
end
