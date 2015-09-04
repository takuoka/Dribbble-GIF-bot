defmodule DribbbleGif.FetchUser do

  @get_followers_num 200

  def get_followers(user_name) do
    {followers, next_cursor} = req_followers(user_name)
    count = length(followers)
    get_followers(user_name, count, {followers, next_cursor})
  end
  def get_followers(user_name, count, {followers, next_cursor}) do
    if count > @get_followers_num do
      followers
    else
      {new_followers, new_next_cursor} = req_followers(user_name, next_cursor)
      count = count + length(followers)
      get_followers(user_name, count, {followers ++ new_followers, new_next_cursor})
    end
  end

  def req_followers(user_name, cursor \\nil) do
    IO.puts "🐝 req_followers..."
    opt = [count: 200]
    if cursor do
      opt = [count: 200, cursor: cursor]
    end
    try do
      res = ExTwitter.followers(user_name, opt)
      followers = res.items
      followers = filter(followers)# delete following user
      {followers, res.next_cursor}
    rescue
      e in ExTwitter.RateLimitExceededError ->
        IO.puts "❌ RateLimitExceededError"
        IO.puts "⏰ retry afeter 20 min..."
        :timer.sleep (1000 * 60 * 20)
        req_followers(user_name, cursor)
    end
  end
  def filter(followers) do
    Enum.filter(followers, fn(f) -> f.following == false && f.follow_request_sent == false end)
  end
end


defmodule DribbbleGif.FetchUser.Util do
  import DribbbleGif.FetchUser
  def test do
    IO.puts "🚶test started."
    followers = get_followers("dribbble")
    IO.inspect followers
    IO.inspect length(followers)
  end
end
