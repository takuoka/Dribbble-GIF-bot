defmodule DribbbleGif.Tweet do

  def try_tweet do
    spawn_monitor DribbbleGif.Tweet, :search_and_tweet, []
    receive do
      {:DOWN, _, _, _, :normal} ->
        IO.puts "✨ Tweet suceed!"
      {:DOWN, _, _, _, error} ->
        IO.puts "🎃 Tweet FAILED!!"
        # IO.inspect error
        re_try_tweet
      _ ->
        IO.puts "❓ error!?"
        re_try_tweet
      # after
      #   1000 * 9000 -> "timeout.."
    end
  end

  def re_try_tweet do
    delay = 1000 * 10
    IO.puts "retry after #{delay}ms ..."
    :timer.sleep(delay)
    try_tweet
  end

  def search_and_tweet do
    item = DribbbleGif.Search.get_new_item
    if item do
      IO.puts "🍓 found new item!"
      tweet(item)
    else
      raise "Can't get new item."
    end
  end

  def tweet(item) do
    {title, link_url, image} = item
    status = title <> "\n" <> link_url
    IO.puts "💬 " <> status
    IO.puts "Tweeting..."
    ExTwitter.API.Tweets.upload_tweet(status, image)
    IO.puts "------- tweeted. ---------"
  end

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
