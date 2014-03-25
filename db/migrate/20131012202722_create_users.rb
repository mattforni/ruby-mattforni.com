class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :null => false
      t.string :email, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.integer :login_count, :null => false, :default => 0
      t.datetime :last_login_at
      t.string :last_login_ip

      t.timestamps
    end
  end
end
