defmodule Sosc.WorkerSupervisor do
  use DynamicSupervisor
  require Logger

  @me WorkerSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
  end


  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_worker() do
    #Logger.debug "New worker created"
    {:ok, _pid} = DynamicSupervisor.start_child(@me, Sosc.Worker)
  end
end
