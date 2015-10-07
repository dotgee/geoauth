class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider, null: false, index: true
      t.string :extern_uid, null: false, index: true

      #
      # from http://davidlesches.com/blog/clean-oauth-for-rails-an-object-oriented-approach
      #
      t.string    :oauth_token, null: true
      t.string    :oauth_secret, null: true
      t.datetime  :oauth_expires, null: true

      
      t.timestamps null: false
    end
  end
end
