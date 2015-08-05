defmodule DribbbleGif.Cache do

  def start_link do
    IO.puts "chache is started."
    Agent.start_link(fn -> [] end)
  end

  def add_url(pid, url) do
    Agent.update pid, fn(list) -> [url|list] end
  end

  def get_list(pid) do
    Agent.get pid, fn(list) -> list end
  end

  def is_contain(pid, url) do
     list = get_list(pid)
     search(list, url)
  end

  defp search([h|t], url) do
      if h == url do
         true
      else
        search(t, url)
      end
  end
  defp search([],url) do
    false
  end
end




defmodule DribbbleGif.Cache.Test do
  def test do
    {:ok, pid} = DribbbleGif.Cache.start_link
    DribbbleGif.Cache.add_url(pid, "aiu")
    DribbbleGif.Cache.add_url(pid, "eee")
    DribbbleGif.Cache.add_url(pid, "ooo")

    IO.inspect DribbbleGif.Cache.get_list(pid)

    IO.inspect DribbbleGif.Cache.is_contain(pid, "aee")
    IO.inspect DribbbleGif.Cache.is_contain(pid, "aiu")
    IO.inspect DribbbleGif.Cache.is_contain(pid, "ooo")
  end
end
