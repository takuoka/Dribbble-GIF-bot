defmodule DribbbleGif.Feeds do
  require HTTPoison
  require Floki

  @dribbble_url "https://dribbble.com"
  @dribbble_gif_now_popular_url "https://dribbble.com/shots?list=animated"
  @dribbble_gif_alltime_popular_url "https://dribbble.com/shots?list=animated&timeframe=ever"

  def fetch(:alltime, page_num) do
    fetch(@dribbble_gif_alltime_popular_url <> "&page=#{page_num}")
  end
  def fetch(:now, page_num) do
    fetch(@dribbble_gif_now_popular_url <> "&page=#{page_num}")
  end
  def fetch(page_url) do
    IO.puts "🐝 load #{page_url} ..."
    res = HTTPoison.get!( page_url )
    %HTTPoison.Response{status_code: 200, body: body} = res
    feeds = Floki.find(body, ".dribbble-img")
    [_|feeds] = feeds # remove first element (empty start)
    Enum.map(feeds, fn(f) -> get_feed_info(f) end)
  end

  defp get_feed_info(feed) do
      IO.puts "-------- parse feed ---------"
      link_url = extract_link(feed)
      gif_url = extract_gif_url(feed)
      title = extract_title(feed)
      {title, link_url, gif_url}
  end

  defp extract_title(feed) do
        {_, _, children_nodes} = feed
        title = children_nodes
            |> Floki.find(".dribbble-over strong")
            |> Floki.text
        IO.puts "🔤 extracted title: #{title}"
        title
  end

  defp extract_link(feed) do
    {_, _, children_nodes} = feed
    href = children_nodes
        |> Floki.find("a.dribbble-link")
        |> Floki.attribute("href")
        |> List.first
    link_url = @dribbble_url <> href
    IO.puts "🔗 extracted link_url: #{link_url}"
    link_url
  end

  defp extract_gif_url(feed) do
    {_, _, children_nodes} = feed

    thumbnail_url = children_nodes
        |> Floki.find("a.dribbble-link picture source")
        |> Floki.attribute("srcset")
        |> List.first

    # cut suffix
    cutLength = 4# ".gif"
    if containString(thumbnail_url, "_still.gif") do
        cutLength = 10
    end
    if containString(thumbnail_url, "_1x.gif") do
        cutLength = 7
    end
    if containString(thumbnail_url, "_teaser.gif") do
        cutLength = 11
    end

    gif_url = String.slice(thumbnail_url, 0, String.length(thumbnail_url) - cutLength) <> ".gif"
    IO.puts "🌱 thumb_url: #{thumbnail_url}"
    IO.puts "🌿 gif_url  : #{gif_url}"
    gif_url
  end

  defp containString(original, str) do
      :binary.match(original, str) != :nomatch
  end
end

defmodule DribbbleGif.Feeds.Test do
  import DribbbleGif.Feeds

  def test do
    fetch(:now, 2)
  end
end
