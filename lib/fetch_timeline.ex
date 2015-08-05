defmodule DribbbleGif.Timeline do
  @max_history_num 3000#4.166666667ヶ月分
  @user_id "dribbble_gif"
  @once_max 200

  def fetch_tweets do
    IO.puts "fetch_tweets..."
    first_tweets = req_self_tl
    IO.puts "fetched"
    fetch_tweets first_tweets, first_tweets
  end
  defp fetch_tweets(last_tweets, all_tweets) do
    IO.puts "🐣 fetch tweets ..."
    max_id = List.last(last_tweets).id - 1
    new_tweets = req_self_tl(max_id)
    all_tweets = all_tweets ++ new_tweets
    case new_tweets do
        [] -> all_tweets
        _ when length(all_tweets) > @max_history_num -> all_tweets
        _ -> fetch_tweets(new_tweets, all_tweets)
    end
  end

  def req_self_tl(max_id \\ nil) do
    options = [user_id: @user_id, count: @once_max]
    if max_id do
      options = [user_id: @user_id, count: @once_max, max_id: max_id]
    end
    IO.puts "🐝 req_self_tl..."
    try do
      ExTwitter.API.Timelines.user_timeline(options)
    rescue
      e in ExTwitter.RateLimitExceededError ->
        IO.puts "❌ RateLimitExceededError"
        IO.puts "⏰ retry afeter 20 min..."
        :timer.sleep (1000 * 60 * 20)
        req_self_tl(max_id)
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
