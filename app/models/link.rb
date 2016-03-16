class Link < ActiveRecord::Base
  include Taggable

  default_scope { order(:read, updated_at: :desc) }

  validates_presence_of :url, :user
  validates_inclusion_of :read, in: [true, false]
  belongs_to :user, required: true
  paginates_per 16

  # TODO: this will be moved to i18n later
  def status
    read ? 'readed' : 'unreaded'
  end

  def update_title_and_description
    UrlScrapperJob.perform_later id
  end
end
