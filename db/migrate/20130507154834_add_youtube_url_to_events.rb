class AddYoutubeUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :youtube_url, :text
  end
end
