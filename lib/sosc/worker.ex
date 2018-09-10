defmodule Sosc.Worker do
  use GenServer, restart: :transient
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end


  def init(:no_args) do
    Process.send_after(self(), :do_one_itr, 0)
    { :ok, nil }
  end

  def handle_info(:do_one_itr, _) do
    Sosc.Sd.next_sequence
    |> add_result
  end

  def add_result(nil) do
    Sosc.CollectResults.done()
    {:stop, :normal, nil}
  end

  def add_result(state) do
    {start,last} = state
    Sosc.CollectResults.result(start, is_perfect_square(start..start+last-1))
    send(self(), :do_one_itr)
    { :noreply, nil }
  end

  def is_perfect_square(range) do
    #Logger.debug "#{range |> Enum.map(&(&1*&1)) |> Enum.sum |> :math.sqrt}"
    sum=range |> Enum.map(&(&1*&1)) |> Enum.sum
    #Logger.debug "range - " <> "#{inspect range}" <> " sum -  #{sum}"
    sum |> :math.sqrt |> checkpf
  end

  def checkpf(n) do
    n==trunc(n)
  end
end
