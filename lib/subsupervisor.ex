defmodule DribbbleGif.SubSupervisor do
  use Supervisor
  #これを一時間に一回落とすことで定期ツイート
  
  def start_link(cache_pid) do
    Supervisor.start_link(__MODULE__, cache_pid)
  end

  def init(cache_pid) do
    supervise [ worker(DribbbleGif.Server, [cache_pid]) ], strategy: :one_for_one
  end
end
