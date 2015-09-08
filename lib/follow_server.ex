defmodule DribbbleGif.UnFollowServer do
  use GenServer

  def start_link() do
    IO.puts "start link follow server:"
    started = GenServer.start_link(__MODULE__, [], name: __MODULE__)
    GenServer.cast(__MODULE__, {:start})
    started
  end

  def handle_cast({:start}, something) do
    IO.puts("start auto aunfollow")
    DribbbleGif.Follow.start_auto_unfollow
    {:noreply, :ok}
  end
end


defmodule DribbbleGif.FollowServer do
  use GenServer

  def start_link() do
    IO.puts "start link follow server:"
    started = GenServer.start_link(__MODULE__, [], name: __MODULE__)
    GenServer.cast(__MODULE__, {:start})
    started
  end

  def handle_cast({:start}, something) do
    IO.puts("start auto aunfollow")
    DribbbleGif.Follow.start_auto_follow
    {:noreply, :ok}
  end
end
