class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :organization
      t.string :api_user
      t.string :api_pass
    end
  end
end
