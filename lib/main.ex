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
  # ✔ ツイート失敗したときにリトライ
  # ✔ All Timeに切り替え
  # ✔ 定期ツイート
  # ✔ デプロイ   elixir --detached -S mix run --no-halt

  # ✔ バグなおす
  # ↓ 大丈夫
  # 自動フォロー機能

  # --- できればあとで ---
  # ツイートの取得も一回にして、メモリ上のmapにアップデートしていく感じにしたい。

  use Application
  def start(_type, _args) do
    IO.puts "🚶 started."
    main
  end

  def main do
    DribbbleGif.Supervisor.start_link
  end
end
