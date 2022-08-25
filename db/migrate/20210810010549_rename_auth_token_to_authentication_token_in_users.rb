class RenameAuthTokenToAuthenticationTokenInUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :auth_token, :authentication_token
    add_index :users, :authentication_token, unique: true
  end
end
