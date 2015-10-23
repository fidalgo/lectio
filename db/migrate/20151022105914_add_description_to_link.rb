class AddDescriptionToLink < ActiveRecord::Migration
  def change
    add_column :links, :description, :string
  end
end
