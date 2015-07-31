defmodule DribbbleGif.Tweet do
  @max_page 20

  def random_gif_tweet do
    IO.puts("---- random_gif_tweet ----")
    page_num = DribbbleGif.Util.random_num(@max_page)
    {title, link_url, gif_url} = DribbbleGif.GetGifUrl.fetch_random_gif_url(page_num)
    unless DribbbleGif.CheckDuplicate.isDuplicated(link_url) do
      status = title <> " " <> link_url
      IO.puts "💬 " <> status
      tweet_gif(status, gif_url)
      IO.puts "------- tweeted. ---------"
      {:ok}
    else
      raise "duplicated item."
    end
  end

  defp tweet_gif(message, url) do
      IO.puts "Downloading image..."
       {:ok, res} = HTTPoison.get(url)
       encoded_image = Base.encode64(res.body)
       IO.puts "Uploading..."
       ExTwitter.API.Tweets.upload_tweet(message, encoded_image)
  end
end
