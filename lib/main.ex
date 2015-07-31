defmodule DribbbleGif do

  # ✔ dribbleのURLももってくる
  # ✔ タイトルも取ってくる
  # ✔ 重複しない → TLとってくる
  # ✔ 成功するまでトライする
  # All Timeもとれるようにしとく
  # 定期ツイート

  def main do
    IO.puts "🚶 started."
    try_tweet
  end


  def try_tweet do
    spawn_monitor DribbbleGif.Tweet, :random_gif_tweet, []
    receive do
      {:DOWN, _, _, _, :normal} ->
        IO.puts "✨ Tweet suceed!"

      {:DOWN, _, _, _, error} ->
        IO.puts "🎃 Tweet FAILED!!"
        IO.inspect error
        re_try_tweet

      _ ->
        IO.puts "❓ error!?"
        re_try_tweet

      # after
      #   1000 * 9000 -> "timeout.."
    end
  end

  # repost after 60 sec
  def re_try_tweet do
    :timer.sleep(1000 * 60)
    try_tweet
  end
end
