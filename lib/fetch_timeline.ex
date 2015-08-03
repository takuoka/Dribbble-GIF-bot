defmodule DribbbleGif.Timeline do
  @max_history_num 3000#4.166666667ヶ月分
  @user_id "dribbble_gif"
  @once_max 200

  def fetch_tweets do
    first_tweets = ExTwitter.API.Timelines.user_timeline([user_id: @user_id, count: @once_max])
    fetch_tweets first_tweets, first_tweets
  end
  defp fetch_tweets(last_tweets, all_tweets) do
    IO.puts "🐣 fetch tweets ..."
    max_id = List.last(last_tweets).id - 1
    new_tweets = ExTwitter.API.Timelines.user_timeline([user_id: @user_id, count: @once_max, max_id: max_id])
    all_tweets = all_tweets ++ new_tweets
    case new_tweets do
        [] -> all_tweets
        _ when length(all_tweets) > @max_history_num -> all_tweets
        _ -> fetch_tweets(new_tweets, all_tweets)
    end
  end
end



defmodule DribbbleGif.Timeline.Util do
  import DribbbleGif.Timeline

  def test do
   tweets = fetch_tweets
   DribbbleGif.Timeline.Util.inspect_tweets tweets
   IO.puts length(tweets)
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
