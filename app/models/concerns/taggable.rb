module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  def tags_list
    tags.pluck(:name)
  end

  def tags_list=(tags)
  end
end