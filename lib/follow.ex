defmodule DribbbleGif.Follow do

  @minimum_follow_delay_min 15
  @follow_random_delay_min_range 60

  @minimum_unfollow_delay_min 10
  @unfollow_random_delay_min_range 50

  def start_auto_follow do
    IO.puts "🚶💌 start auto follow..."
    users = fetchUsersToFollow
    IO.puts "✨ follow loop start"
    user_action_loop(users, &follow/1, &gen_follow_delay_min/0)
  end

  def start_auto_unfollow do
    IO.puts "🚶❎ start auto follow..."
    followings = fetchUsersToUnFollow
    IO.puts "========= un-follow user ==========="
    IO.inspect followings
    IO.puts "========= un-follow user ==========="
    IO.puts "✨ un-follow loop start"
    user_action_loop(followings, &unfollow/1, &gen_unfollow_delay_min/0)
  end

  def user_action_loop([user|users], action_func, gen_delay_min_func) do
    action_func.(user)
    delay_min = gen_delay_min_func.()
    delay_msec = delay_min * 60 * 1000
    IO.puts "⏰ re-do after #{delay_min}min..."
    :timer.sleep(delay_msec)
    user_action_loop(users, action_func, gen_delay_min_func)
  end
  def unfollow_loop([], action_func, gen_delay_min_func) do
    raise "✨✨restart this process!! ✨✨"
  end

  def gen_follow_delay_min do
    @minimum_follow_delay_min + DribbbleGif.Util.random_num(@follow_random_delay_min_range)
  end
  def gen_unfollow_delay_min do
    @minimum_unfollow_delay_min + DribbbleGif.Util.random_num(@unfollow_random_delay_min_range)
  end
  def gen_delay_min_zero do
    0
  end


  def fetchUsersToFollow do
    followers = DribbbleGif.FetchUser.get_followersToFollow("dribbble")
      |> Enum.map(fn(f) -> f.screen_name end)
  end
  def fetchUsersToUnFollow do
    followings = DribbbleGif.FetchUser.getFollowingToUnfollow()
      |> Enum.map(fn(f) -> f.screen_name end)
      |> Enum.reverse()
  end

  def unfollow(name) do
    IO.puts "🎃 @#{name} un-following..."
    user = ExTwitter.unfollow(name)
    IO.puts "❎ @#{name} un-followed!"
    true
  end
  def follow(name) do
    IO.puts "💌 @#{name} following..."
    user = ExTwitter.follow(name)
    IO.puts "✅ @#{name} followed!"
    true
  end
end
