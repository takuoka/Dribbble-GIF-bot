defmodule DribbbleGif.GetGifUrl do
  require HTTPoison
  require Floki
  require Timex

  @dribbble_gif_now_popular_url "https://dribbble.com/shots?list=animated"

  def fetch_random_gif_url(page) do
    page_url = @dribbble_gif_now_popular_url <> "&page=#{page}"
    IO.puts "🐝 #{page_url} ..."
    res = HTTPoison.get!( page_url )
    %HTTPoison.Response{status_code: 200, body: body} = res
    extract_random_gif_url(body)
  end

  defp extract_random_gif_url(body) do
      feeds = Floki.find(body, ".dribbble-img")
      [_|feeds] = feeds # remove first element (empty start)
      # get random feed element
      feeds = List.to_tuple(feeds)
      random_index = DribbbleGif.Util.random_num(tuple_size(feeds)) - 1
      feed = elem(feeds, random_index)
      extract_gif_url(feed)
  end

  defp extract_gif_url(feed_elem) do
      # get url
      {tag_name, attributes, children_nodes} = feed_elem
      gifUrl = children_nodes |> List.first |> elem(2) |> List.first |> elem(2) |> List.first |> elem(1) |> List.first |> elem(1)
      # _teaser をけす
      String.slice(gifUrl, 0, String.length(gifUrl) - 11) <> ".gif"
  end
end
