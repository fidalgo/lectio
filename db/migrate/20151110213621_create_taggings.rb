class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag, index: true
      t.references :taggable, polymorphic: true, index: true
      t.references :tagger, polymorphic: true, index: true
      t.datetime :created_at
    end
  end
end
