defmodule DribbbleGif.Search do
  alias DribbbleGif.Feeds
  alias DribbbleGif.Timeline
  alias DribbbleGif.CheckDuplicate
  @max_page_for_now_list 20

  def search_item(cache_pid) do
    feed = search_item(:now, cache_pid)
    if feed do
      feed
    else
      search_item(:alltime, cache_pid)# newから取れなかった場合 全てに切り替える
    end
  end
  defp search_item(type, cache_pid) do
    tweets = Timeline.fetch_tweets
    search_item(type, 1, tweets, cache_pid)
  end
  defp search_item(type, page, tweets, cache_pid) do
    IO.puts "📰 search from #{type}, #{page} ... "
    feeds = Feeds.fetch(type, page)
    feed = get_unduplicated_feed(feeds, tweets, cache_pid)
    if feed do
      feed
    else
      next_page = page + 1
      if type == :now do
        maxpage = @max_page_for_now_list
      else
        maxpage = 40
      end
      if next_page < maxpage do
        search_item(type, page + 1, tweets, cache_pid)
      else
        nil
      end
    end
  end


  defp get_unduplicated_feed([feed|tail], tweets, cache_pid) do
    {title, link_url, gif_url} = feed
    IO.puts "* #{title}"
    unless CheckDuplicate.isDuplicated(link_url, tweets) do
      image = download_and_check_image(gif_url, cache_pid)
      if image do
        feed = Tuple.insert_at(feed, 3, image)#{title, link_url, gif_url, image}
        feed
      else
        get_unduplicated_feed(tail, tweets, cache_pid)
      end
    else
      get_unduplicated_feed(tail, tweets, cache_pid)
    end
  end
  defp get_unduplicated_feed([], tweets, cache_pid) do
    nil
  end

  defp download_and_check_image(url, cache_pid) do
    if DribbbleGif.Cache.is_contain(cache_pid, url) do
      IO.puts "too big image."
      nil
    else
      IO.puts "📦 download image ..."
      IO.puts url
      # =========== fix me ==================================================================
      if url == "https://d13yacurqjgara.cloudfront.net/users/912401/screenshots/2211615/30_fps_full.gif" do
        DribbbleGif.Cache.add_url(cache_pid, url)
        nil
      end
      # =============== fix me ==============================================================
      {:ok, res} = HTTPoison.get(url)
      [_|[contentInfo|_]] = res.headers
      if (contentInfo |> elem(0)) == "Content-Length" do
        size_of_byte = contentInfo |> elem(1) |> Integer.parse |> elem(0)
        mega_byte = size_of_byte / 1000 / 1000
        IO.inspect mega_byte
        if mega_byte < 5 do
          image = Base.encode64(res.body)
          image
        else
          IO.puts "😂 image is too big."
          DribbbleGif.Cache.add_url(cache_pid, url)
          nil
        end
      else
        IO.puts "😓 cannot download image."
        IO.inspect url
        IO.inspect res
        DribbbleGif.Cache.add_url(cache_pid, url)
        nil
      end
    end
  end
end
