defmodule DribbbleGif do

  use Application
  def start(_type, _args) do
    IO.puts "🚶 started."
    main
  end

  def main do
    DribbbleGif.Supervisor.start_link
  end
end
