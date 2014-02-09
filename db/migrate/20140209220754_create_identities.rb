class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities, :force => true do |t|
      t.string :email, :null => false
      t.string :password_digest
      t.integer :user_id, :null => false
    end
  end
end
