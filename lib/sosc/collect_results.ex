defmodule Sosc.CollectResults do
  use GenServer

  @me CollectResults



  def start_link(worker_count) do
    GenServer.start_link(__MODULE__, worker_count, name: @me)
  end

  def done() do
    GenServer.cast(@me, :done)
  end

  def result(start, valid) do
    GenServer.cast(@me, { :result, start, valid })
  end



  def init(worker_count) do
    Process.send_after(self(), :kickoff, 0)
    { :ok, worker_count }
  end

  def handle_info(:kickoff, worker_count) do
    1..worker_count
    |> Enum.each(fn _ -> Sosc.WorkerSupervisor.add_worker() end)
    { :noreply, worker_count }
  end

  def handle_cast(:done, _worker_count = 1) do
    report_results()
    System.halt(0)
  end

  def handle_cast(:done, worker_count) do
    { :noreply, worker_count - 1 }
  end

  def handle_cast({:result, start, valid}, worker_count) do
    Sosc.Results.add_valid_solution(start,valid)
    { :noreply, worker_count }
  end

  def report_results() do
    #IO.puts "Results:\n"
    res= Sosc.Results.sort()
    case length(res) do
      0 -> IO.puts("No such sequence found.")
      _ -> res |> Enum.each(&IO.inspect/1)
    end
  end
end
