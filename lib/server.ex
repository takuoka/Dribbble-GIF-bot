defmodule DribbbleGif.Server do
  use GenServer

  def start_link(cache_pid) do
    started = GenServer.start_link(__MODULE__, cache_pid, name: __MODULE__)
    search_and_tweet
    started
  end

  def search_and_tweet() do
    IO.puts "search_and_tweet..."
    GenServer.cast(__MODULE__, {:search_and_tweet})
  end
  def wait_and_crash do
    GenServer.cast(__MODULE__, {:wait_and_crash})
  end

  def handle_cast({:search_and_tweet}, cache_pid) do
    # unless DribbbleGif.Util.random_num(10) == 1 do
    #   :timer.sleep(1000)
    #   raise "Test error"
    # end
    item = DribbbleGif.Search.search_item(cache_pid)
    if item do
      IO.puts "🍓 found new item!"
      tweet(item, cache_pid)
      wait_and_crash
    else
      raise "Can't get new item."
    end
    {:noreply, :ok}
  end

  def handle_cast({:wait_and_crash}, cache_pid) do
    IO.puts "⏰ restart after 1 hour... 😪"
    :timer.sleep(1000 * 60 * 60)
    raise "✨✨restart this process!! ✨✨"
    {:noreply, :ok}
  end

  def tweet(item, cache_pid) do
    {title, link_url, gif_url, image} = item
    status = title <> "\n" <> link_url
    IO.puts "💬 " <> status
    IO.puts "Tweeting..."
    try do
      ExTwitter.API.Tweets.upload_tweet(status, image)
      IO.puts "------- tweeted. ---------"
    rescue
      e in ExTwitter.Error ->
        IO.puts "🎃 TWEET ERROR"
        if e.message == "The validation of media ids failed." do
          IO.puts "❌❌ The validation of media ids failed. ❌❌"
          IO.puts "image url: " <> gif_url
          DribbbleGif.Cache.add_url(cache_pid, gif_url)
          IO.puts "Invalid GifUrl was chached! 😁"
          raise "✨✨Restart this process!!✨✨"
        end
    end
  end
end
