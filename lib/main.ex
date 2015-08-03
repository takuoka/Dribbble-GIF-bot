defmodule DribbbleGif do

  # chokidar **/*.exs **/*.ex -c 'iex -S mix run -e "DribbbleGif.main"'
  # ✔ dribbleのURLももってくる
  # ✔ タイトルも取ってくる
  # ✔ 重複しない → TLとってくる
  # ✔ 成功するまでトライする
  # ✔ ページをだんだん遡るようにする
  # ✔ キャッシュ用モジュール作成
  # ✔ でかすぎる画像のURLをメモリでキャッシュ
  # ✔ supervise
  # ✔ one_for_one : 画像URLキャッシュ, サーチ&Tweet
  # ツイート失敗したときにリトライ
  # All Timeからのランダムピックを用意→しこむ
  # 定期ツイート
  # デプロイ
  # --- できればあとで ---
  # ツイートの取得も一回にして、メモリ上のmapにアップデートしていく感じにしたい。

  use Application
  def start(_type, _args) do
    IO.puts "🚶 started."
    DribbbleGif.Supervisor.start_link
  end

  def main do
    DribbbleGif.Supervisor.start_link
    DribbbleGif.Server.search_and_tweet
  end
end
