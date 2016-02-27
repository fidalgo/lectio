class Tagging < ActiveRecord::Base
  belongs_to :tag, required: true
  belongs_to :taggable, polymorphic: true, required: true
  belongs_to :tagger, polymorphic: true, required: true
end
