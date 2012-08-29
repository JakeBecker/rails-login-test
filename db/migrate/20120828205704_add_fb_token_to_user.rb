class AddFbTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_token, :string
    add_column :users, :facebook_token_expires, :timestamp
  end
end
