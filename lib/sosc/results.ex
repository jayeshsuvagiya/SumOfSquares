defmodule Sosc.Results do

  use GenServer

  @me Results




  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: @me)
  end

  def add_valid_solution(start, valid) do
    GenServer.cast(@me, { :add, start, valid })
  end

  def sort() do
    GenServer.call(@me, :sort)
  end



  def init(:no_args) do
    { :ok, %{} }
  end


  def handle_cast({ :add, start, valid }, results) do
    results =Map.put(results,start,valid)
    { :noreply, results }
  end

  def handle_call(:sort, _from, results) do
    {
      :reply,
      get_result_and_sort(results),
      results
    }
  end


  def get_result_and_sort(results) do
    Enum.sort(for {a, true} <- results, do: a)
  end


end
