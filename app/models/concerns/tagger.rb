module Tagger
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :tagger, dependent: :destroy
    has_many :tags, through: :taggings, source: :tag
  end

  def tag(taggable, with)
    tag_names = with.flatten.uniq.map(&:strip).reject(&:blank?)
    delete_taggins(taggable, taggable.tags_list - tag_names)
    tag_names.each do |name|
      tag = Tag.where(name: name).first_or_create!
      taggings.where(tag: tag, taggable: taggable).first_or_create!
    end
  end

  def tags_list
    tags.pluck(:name)
  end

  private

  def delete_taggins(taggable, tags_list)
    tags_list.each do |tag_to_delete|
      tag = Tag.where(name: tag_to_delete)
      taggings.where(tag: tag, taggable: taggable).each(&:destroy)
    end
  end
end
