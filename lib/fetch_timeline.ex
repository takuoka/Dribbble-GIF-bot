defmodule DribbbleGif.FetchTimeline do
  @max_history_num 1000#1ヶ月ちょい
  @user_id "dribbble_gif"
  @once_max 200
  alias ExTwitter.API.Timelines, as: API

  def test do
   tweets = fetch_tweets
   inspect_tweets tweets
   IO.puts length(tweets)
  end


  def fetch_tweets do
    first_tweets = API.user_timeline([user_id: @user_id, count: @once_max])
    fetch_tweets first_tweets, first_tweets
  end
  defp fetch_tweets(last_tweets, all_tweets) do
    IO.puts "🐝 fetch tweets ..."
    max_id = List.last(last_tweets).id - 1
    new_tweets = API.user_timeline([user_id: @user_id, count: @once_max, max_id: max_id])
    all_tweets = all_tweets ++ new_tweets
    case new_tweets do
        [] -> all_tweets
        _ when length(all_tweets) > @max_history_num -> all_tweets
        _ -> fetch_tweets(new_tweets, all_tweets)
    end
  end


  def inspect_tweets(tweets) do
      Enum.map(tweets, fn(t) -> inspect_tweet(t) end)
  end
  defp inspect_tweet(t) do
      IO.puts "💬 --------------"
      IO.inspect t.created_at
      IO.inspect t.id
      IO.inspect t.text
  end
end
