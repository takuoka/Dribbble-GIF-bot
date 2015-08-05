defmodule DribbbleGif.Supervisor do
  use Supervisor

  def start_link do
    res = {:ok, sup} = Supervisor.start_link(__MODULE__, [])
    {:ok, cache_pid} = Supervisor.start_child(sup, worker(DribbbleGif.Cache, []))
    Supervisor.start_child(sup, supervisor(DribbbleGif.SubSupervisor, [cache_pid]))
    Supervisor.start_child(sup, worker(DribbbleGif.FollowServer, []))
    res
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
