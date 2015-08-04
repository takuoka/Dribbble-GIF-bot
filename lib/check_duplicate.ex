defmodule DribbbleGif.CheckDuplicate do

  def test do
    IO.puts "test"
    test_url = "https://dribbble.com/shots/2169940-Fullscreen-Website-Scroll-Effect"
    IO.puts isDuplicated(test_url)
  end

  def isDuplicated(url, tweets) do
    urls = Enum.map(tweets, fn(t) -> t.entities.urls end)
    search_url(urls, url)
  end

  def isDuplicated(url) do
    isDuplicated(url, DribbbleGif.FetchTimeline.fetch_tweets)
  end

  defp search_url([h|t], url) do
    if h == [] do
      search_url(t, url)
    else
      if is_contain(h, url) do
        true
      else
        search_url(t, url)
      end
    end
  end
  defp search_url([], url) do
    false
  end

  def is_contain([h|t], url) do
    if h.expanded_url == url do
      true
    else
      is_contain(t, url)
    end
  end
  def is_contain([], url) do
    false
  end

end
