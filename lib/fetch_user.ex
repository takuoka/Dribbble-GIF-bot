defmodule DribbbleGif.FetchUser do

  @get_followers_num 200
  @get_following_limit 400

  def get_followersToFollow(user_name) do
    get_followersWithFilter(user_name, &filterToFollow/1)
  end

  def getFollowingToUnfollow do
    followings = get_followingWithFilter("dribbble_gif", nil)
    followers = getAllFollowers("dribbble_gif")
    # followingsをfilterしてfollowerじゃないヤツだけにする

    # def is_follower(id) do
    #     is_contain(id, followers)
    # end
    # followerじゃないやつだけ
    followingToUnfollow = Enum.filter(followings, fn(f) -> is_contain(f.screen_name, followers) == false end)

    IO.puts length(followings)
    IO.puts length(followers)
    IO.puts length(followingToUnfollow)

    require IEx; IEx.pry
  end

  def getAllFollowers(user_name) do
    get_followersWithFilter(user_name, nil)
  end

  def get_followersWithFilter(user_name, filter_func) do
    requestToLimit(&req_followers/2, user_name, filter_func, @get_followers_num)
  end
  def get_followingWithFilter(user_name, filter_func) do
    requestToLimit(&req_following/2, user_name, filter_func, @get_following_limit)
  end

  def req_followers(user_name, cursor \\nil) do
    reqAPI(user_name, &ExTwitter.followers/2, cursor)
  end
  def req_following(user_name, cursor \\nil) do
    reqAPI(user_name, &ExTwitter.friends/2, cursor)
  end

  def filterToFollow(followers) do
    Enum.filter(followers, fn(f) -> f.following == false && f.follow_request_sent == false end)
  end
  # def filterToUnfollow(followers) do
  #   Enum.filter(followers, fn(f) -> f.following == false && f.follow_request_sent == false end)
  # end

  def requestToLimit(req_func, user_name, filter_func, limit) do
    {followers, next_cursor} = req_func.(user_name, nil)
    if filter_func do
      followers = filter_func.(followers)
    end
    count = length(followers)
    requestToLimit(req_func, user_name, count, {followers, next_cursor}, filter_func, limit)
  end
  def requestToLimit(req_func, user_name, count, {followers, next_cursor}, filter_func, limit) do
    if count > limit do
      followers
    else
      {new_followers, new_next_cursor} = req_func.(user_name, next_cursor)
      if filter_func do
        new_followers = filter_func.(new_followers)
      end
      count = count + length(followers)
      requestToLimit(req_func, user_name, count, {followers ++ new_followers, new_next_cursor}, filter_func, limit)
    end
  end

  def reqAPI(user_name, api_func ,cursor \\nil) do
    IO.puts "🐝 req_followers..."
    opt = [count: 200]
    if cursor do
      opt = [count: 200, cursor: cursor]
    end
    try do
      res = api_func.(user_name, opt)#ExTwitter.followers(user_name, opt)
      followers = res.items
      {followers, res.next_cursor}
    rescue
      e in ExTwitter.RateLimitExceededError ->
        IO.puts "❌ RateLimitExceededError"
        IO.puts "⏰ retry afeter 20 min..."
        :timer.sleep (1000 * 60 * 20)
        req_followers(user_name, cursor)
    end
  end



  def is_contain(id, users) do
     search(users, id)
  end
  defp search([h|t], id) do
      if h.screen_name == id do
         true
      else
        search(t, id)
      end
  end
  defp search([],id) do
    false
  end
end


defmodule DribbbleGif.FetchUser.Util do
  import DribbbleGif.FetchUser
  def test do
    IO.puts "🚶test started."
    followers = get_followersToFollow("dribbble")
    IO.inspect followers
    IO.inspect length(followers)
  end
end
