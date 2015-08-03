defmodule DribbbleGif do

  # chokidar **/*.exs **/*.ex -c 'iex -S mix run -e "DribbbleGif.main"'
  # ✔ dribbleのURLももってくる
  # ✔ タイトルも取ってくる
  # ✔ 重複しない → TLとってくる
  # ✔ 成功するまでトライする
  # ✔ ページをだんだん遡るようにする
  # ✔ キャッシュ用モジュール作成
  # でかすぎる画像のURLをメモリでキャッシュ
  # supervise
  # one_for_one : 画像URLキャッシュ, サーチ&Tweet
  # All Timeからのランダムピックを用意→しこむ
  # 定期ツイート
  # デプロイ

  def main do
    IO.puts "🚶 started."
    DribbbleGif.Tweet.try_tweet()
  end
end
