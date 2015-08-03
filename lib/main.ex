defmodule DribbbleGif do

  # ✔ dribbleのURLももってくる
  # ✔ タイトルも取ってくる
  # ✔ 重複しない → TLとってくる
  # ✔ 成功するまでトライする
  # ✔ ページをだんだん遡るようにする
  # ✔ キャッシュ用モジュール作成
  # でかすぎる画像のURLをメモリでキャッシュ
  # All Timeからのランダムピックを用意→しこむ
  # supervise
  # 定期ツイート
  # デプロイ

  alias DribbbleGif.Search
  alias DribbbleGif.Tweet

  def main do
    IO.puts "🚶 started."
    # try_tweet
  end

  def tweet do
    item = Search.get_new_item
    if item do
      IO.puts "🍓 found new item!"
      # Tweet.tweet(item)
    else
      raise "Can't get new item."
    end
  end

  def try_tweet do
    spawn_monitor DribbbleGif, :tweet, []
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
    :timer.sleep(1000 * 10)
    try_tweet
  end
end
