defmodule DribbbleGif.Follow do

  @min_follow_delay 1000 * 60 * 15
  @random_delay_range 1000 * 60 * 60

  def start do
    IO.puts "🚶 start auto follow..."
    users = fetch
    IO.inspect users
    follow_loop(users)
  end

  def follow_loop([user|users]) do
    follow(user)
    delay = gen_delay
    delay_m = delay / 1000 / 60
    IO.puts "⏰ follow after #{delay_m}min..."
    :timer.sleep(delay)
    follow_loop(users)
  end
  def follow_loop([]), do: start

  def gen_delay, do: @min_follow_delay + DribbbleGif.Util.random_num(@random_delay_range)

  def fetch do
    followers = DribbbleGif.FetchUser.get_followersToFollow("dribbble")
      |> Enum.map(fn(f) -> f.screen_name end)
  end

  def follow(name) do
    IO.puts "💌 @#{name} following..."
    user = ExTwitter.follow(name)
    if user.following == true do
      IO.puts "✅ @#{name} followed!"
      true
    else
      IO.inspect user
      IO.puts "❓ follow failed?"
      false
    end
  end
end
