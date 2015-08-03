defmodule DribbbleGif.Search do
  alias DribbbleGif.Feeds
  alias DribbbleGif.Timeline
  alias DribbbleGif.CheckDuplicate
  @max_page_for_now_list 20

  def get_new_item(cache_pid) do
    feed = search_from_new(cache_pid)
    if feed do
      feed
    else
      # 全てからランダムで取ってくる
    end
  end

  def search_from_new(cache_pid) do
    tweets = Timeline.fetch_tweets
    search_from_new(1, tweets, cache_pid)
  end
  def search_from_new(page, tweets, cache_pid) do
    IO.puts "📰 search_from_new #{page} ... "
    feeds = Feeds.fetch_from_now(page)
    feed = get_unduplicated_feed(feeds, tweets, cache_pid)
    if feed do
      feed
    else
      next_page = page + 1
      if next_page < @max_page_for_now_list do
        search_from_new(page + 1, tweets, cache_pid)
      else
        nil
      end
    end
  end

  def get_unduplicated_feed([feed|tail], tweets, cache_pid) do
    {title, link_url, gif_url} = feed
    IO.puts "* #{title}"
    unless CheckDuplicate.isDuplicated(link_url, tweets) do
      image = download_and_check_image(gif_url, cache_pid)
      if image do
        feed = put_elem(feed, 2, image)
        feed
      else
        get_unduplicated_feed(tail, tweets, cache_pid)
      end
    else
      get_unduplicated_feed(tail, tweets, cache_pid)
    end
  end
  def get_unduplicated_feed([], tweets, cache_pid) do
    nil
  end

  def download_and_check_image(url, cache_pid) do
    if DribbbleGif.Cache.is_contain(cache_pid, url) do
      IO.puts "too big image."
      nil
    else
      IO.puts "📦 download image ..."
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
        nil
      end
    end
  end
end



# defmodule DribbbleGif.Search.Util do
#     import DribbbleGif.Search
#     alias DribbbleGif.Feeds
#     alias DribbbleGif.Timeline
#     alias DribbbleGif.CheckDuplicate
#
#     def test do
#       feed = get_new_item
#       if feed do
#         IO.puts "🍓 found new item!"
#         {title, link_url, image} = feed
#         IO.puts "let's tweet"
#         # tweet
#       else
#         # げっとできなかった場合。。そんなのないはず
#         raise "Can't get new item..."
#       end
#     end
# end
