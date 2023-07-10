class ChangeUsersProfileToString < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :profile, :string
  end
  def down
    change_column :users, :profile, :text
  end
end
