defmodule DribbbleGif do

  # ✔ dribbleのURLももってくる
  # ✔ タイトルも取ってくる
  # ✔ 重複しない → TLとってくる
  # 定期ツイート
  # All Timeもとりはじめる

  @max_page 20

  def main do
    random_gif_tweet
  end

  def random_gif_tweet do
    IO.puts("---- random_gif_tweet ----")
    page_num = DribbbleGif.Util.random_num(@max_page)
    {title, link_url, gif_url} = DribbbleGif.GetGifUrl.fetch_random_gif_url(page_num)
    unless DribbbleGif.CheckDuplicate.isDuplicated(link_url) do
      status = title <> " " <> link_url
      IO.puts "💬 " <> status
      tweet_gif(status, gif_url)
      IO.puts "------- tweeted. ---------"
    else
      IO.puts "duplicated!!!! ===="
    end
  end

  def tweet_gif(message, url) do
      IO.puts "Downloading image..."
       {:ok, res} = HTTPoison.get(url)
       encoded_image = Base.encode64(res.body)
       IO.puts "Uploading..."
       ExTwitter.API.Tweets.upload_tweet(message, encoded_image)
  end
end
