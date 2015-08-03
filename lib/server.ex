defmodule DribbbleGif.Server do
  use GenServer

  def start_link(cache_pid) do
    GenServer.start_link(__MODULE__, cache_pid, name: __MODULE__)
  end

  def search_and_tweet() do
    GenServer.cast __MODULE__, {:search_and_tweet}
  end

  def handle_cast({:search_and_tweet}, cache_pid) do
    item = DribbbleGif.Search.get_new_item(cache_pid)
    if item do
      IO.puts "🍓 found new item!"
      tweet(item)
    else
      raise "Can't get new item."
    end
    {:noreply, :ok}
  end
  # def handle_cast({:search_and_tweet}, _from, cache_pid) do
  #   item = DribbbleGif.Search.get_new_item(cache_pid)
  #   if item do
  #     IO.puts "🍓 found new item!"
  #     tweet(item)
  #   else
  #     raise "Can't get new item."
  #   end
  #   {:reply, :ok, cache_pid}
  # end

  def tweet(item) do
    {title, link_url, image} = item
    status = title <> "\n" <> link_url
    IO.puts "💬 " <> status
    IO.puts "Tweeting..."
    ExTwitter.API.Tweets.upload_tweet(status, image)
    IO.puts "------- tweeted. ---------"
  end
end
