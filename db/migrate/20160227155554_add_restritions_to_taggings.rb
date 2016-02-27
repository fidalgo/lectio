class AddRestritionsToTaggings < ActiveRecord::Migration
  def change
    change_column_null :taggings, :tag_id, false
    change_column_null :taggings, :taggable_id, false
    change_column_null :taggings, :taggable_type, false
    change_column_null :taggings, :tagger_id, false
    change_column_null :taggings, :tagger_type, false
  end
end
