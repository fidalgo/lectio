class AddRestritionsToLink < ActiveRecord::Migration
  def change
    change_column_null :links, :url, false
    change_column_null :links, :user_id, false
    change_column_null :links, :read, false
  end
end
