class AddIndexToTags < ActiveRecord::Migration
  def change
    change_column_null :tags, :name, false
    add_index :tags, :name, unique: true
  end
end
