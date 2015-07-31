defmodule DribbbleGif.CheckDuplicate do

  def test do
    IO.puts "test"
    test_url = "https://dribbble.com/shots/2169940-Fullscreen-Website-Scroll-Effect"
    IO.puts isDuplicated(test_url)
  end

  def isDuplicated(url) do
    tweets = DribbbleGif.FetchTimeline.fetch_tweets
    urls = Enum.map(tweets, fn(t) -> t.entities.urls end)
    search_url(urls, url)
  end

  defp search_url([h|t], url) do
    if h == [] do
      search_url(t, url)
    else
      if List.first(h).expanded_url == url do
        true
      else
        search_url(t, url)
      end
    end
  end
  defp search_url([], url) do
    false
  end
end
