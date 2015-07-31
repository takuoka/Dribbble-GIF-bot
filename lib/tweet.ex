defmodule DribbbleGif.Tweet do

  def tweet(feed) do
    {title, link_url, image} = feed
    status = title <> "\n" <> link_url
    IO.puts "💬 " <> status
    ExTwitter.API.Tweets.upload_tweet(status, image)
    IO.puts "------- tweeted. ---------"
  end

  # defp tweet_gif(message, url) do
  #   IO.puts "Downloading image..."
  #    {:ok, res} = HTTPoison.get(url)
  #    encoded_image = Base.encode64(res.body)
  #    IO.puts "Uploading..."
  #    ExTwitter.API.Tweets.upload_tweet(message, encoded_image)
  # end

  # def random_gif_tweet do
  #   IO.puts("---- random_gif_tweet ----")
  #   page_num = DribbbleGif.Util.random_num(@max_page)
  #   feed = DribbbleGif.GetGifUrl.fetch_random_gif_url(page_num)
  #   {title, link_url, gif_url} = feed
  #   unless DribbbleGif.CheckDuplicate.isDuplicated(link_url) do
  #     tweet(feed)
  #   else
  #     raise "duplicated item."
  #   end
  # end
end
