defmodule DribbbleGif.Feeds do
  require HTTPoison
  require Floki
  require Timex

  @dribbble_url "https://dribbble.com"
  @dribbble_gif_now_popular_url "https://dribbble.com/shots?list=animated"

  def fetch_from_now(page) do
    page_url = @dribbble_gif_now_popular_url <> "&page=#{page}"
    IO.puts "🐝 #{page_url} ..."
    res = HTTPoison.get!( page_url )
    %HTTPoison.Response{status_code: 200, body: body} = res
    feeds = Floki.find(body, ".dribbble-img")
    [_|feeds] = feeds # remove first element (empty start)
    feeds
    Enum.map(feeds, fn(f) -> get_feed_info(f) end)
  end

  defp get_feed_info(feed) do
      link_url = extract_link(feed)
      gif_url = extract_gif_url(feed)
      title = extract_title(feed)
      {title, link_url, gif_url}
  end

  defp extract_title(feed_elem) do
       {_, _, children_nodes} = feed_elem
       children_nodes |> List.first |> elem(2) |> List.first |> elem(1) |> List.last |> elem(1)
  end

  defp extract_link(feed_elem) do
    {_, _, children_nodes} = feed_elem
    link_url =  children_nodes |> List.first |> elem(1) |> List.last |> elem(1)
    link_url = @dribbble_url <> link_url
  end

  defp extract_gif_url(feed_elem) do
    # get url
    {_, _, children_nodes} = feed_elem
    gifUrl = children_nodes |> List.first |> elem(2) |> List.first |> elem(2) |> List.first |> elem(1) |> List.first |> elem(1)
    # remove "_teaser"
    String.slice(gifUrl, 0, String.length(gifUrl) - 11) <> ".gif"
  end

  #
  # def fetch_random_gif_url(page) do
  #   # page_url = @dribbble_gif_now_popular_url <> "&page=#{page}"
  #   # IO.puts " #{page_url} ..."
  #   # res = HTTPoison.get!( page_url )
  #   # %HTTPoison.Response{status_code: 200, body: body} = res
  #   extract_random_gif_url(get_feeds_from_now(page))
  # end
  #
  # defp extract_random_gif_url(feeds) do
  #   # get random feed element
  #   feeds = List.to_tuple(feeds)
  #   random_index = DribbbleGif.Util.random_num(tuple_size(feeds)) - 1
  #   feed = elem(feeds, random_index)
  #   # parse html
  #   link_url = extract_link(feed)
  #   gif_url = extract_gif_url(feed)
  #   title = extract_title(feed)
  #   {title, link_url, gif_url}
  # end
  #
end
