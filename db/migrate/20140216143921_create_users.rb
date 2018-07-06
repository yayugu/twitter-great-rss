class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :twitter_id
      t.string :twitter_access_token
      t.string :twitter_access_secret
      t.string :url_id_hash
      t.timestamps

      t.index :twitter_id
      t.index :url_id_hash
    end
  end
end
