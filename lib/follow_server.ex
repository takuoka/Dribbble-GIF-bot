defmodule DribbbleGif.FollowServer do
  use GenServer

  def start_link() do
    IO.puts "start link follow server"
    started = GenServer.start_link(__MODULE__, [], name: __MODULE__)
    start
    started
  end

  def start() do
    IO.puts("start follow server")
    GenServer.cast(__MODULE__, {:start})
  end

  def handle_cast({:start}, something) do
    IO.puts("start")
    DribbbleGif.Follow.start
    {:noreply, :ok}
  end
end
