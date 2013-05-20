class Testimony < ActiveRecord::Base
  attr_accessible :content, :screen_name, :tweet_id

  def self.pull_tweets
  hashtags = (TwitterTag.where(:active => true).map{|t| "#" + t.tag }.join(" OR ") + " OR @chevalmumbai")

  Twitter.search(hashtags, :count => 10, :result_type => "recent").results.each do |tweet|
    unless exists?(tweet_id: tweet.id)
      create!(
        tweet_id: tweet.id,
        content: tweet.text,
        screen_name: tweet.user.screen_name,
      )
    end
  end
end
end
