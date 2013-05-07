class CreateTwitterTags < ActiveRecord::Migration
  def change
    create_table :twitter_tags do |t|
      t.string :tag
      t.boolean :active

      t.timestamps
    end
  end
end
