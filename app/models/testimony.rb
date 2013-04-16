class Testimony < ActiveRecord::Base
  attr_accessible :content, :screen_name, :tweet_id

  def self.pull_tweets
  Twitter.search("#cheval_mumbai", :count => 10, :result_type => "recent", :lang => "en").results.each do |tweet|
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
