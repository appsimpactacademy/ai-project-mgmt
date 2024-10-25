class CreateSocialNetworks < ActiveRecord::Migration[7.0]
  def change
    create_table :social_networks do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :linkedin_url
      t.string :github_url
      t.string :stackoverflow_url
      t.string :twitter_url
      t.string :youtube_url
      t.string :website_url

      t.timestamps
    end
  end
end
