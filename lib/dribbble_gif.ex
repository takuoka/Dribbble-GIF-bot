defmodule DribbbleGif do

  # dribbleのURLももってくる
  # 重複しない
  # 定期ツイート

  def main do
    #   random_gif_tweet

    IO.puts "test.."
    page_num = DribbbleGif.Util.random_num(10)
    gif_url = DribbbleGif.GetGifUrl.fetch_random_gif_url(page_num)
    IO.puts gif_url
  end

  def random_gif_tweet do
      IO.puts("---- random_gif_tweet ----")
      page_num = DribbbleGif.Util.random_num(10)
      gif_url = DribbbleGif.GetGifUrl.fetch_random_gif_url(page_num)
      IO.puts "🍓 " <> gif_url
      IO.puts "uploading..."
      tweet_gif("test", gif_url)
      IO.puts "------- tweeted. ---------"
  end

  def tweet_gif(message, url) do
       {:ok, res} = HTTPoison.get(url)
       encoded_image = Base.encode64(res.body)
       ExTwitter.API.Tweets.upload_tweet(message, encoded_image)
  end
end
