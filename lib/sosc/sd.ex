defmodule Sosc.Sd do
  use GenServer
  require Logger
  @me Sd

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: @me)
  end

  def next_sequence() do
    GenServer.call(@me, :next_sequence)
  end


  @spec init(any()) :: {:ok, any()}
  def init(args) do
    {:ok,args}
  end

  def handle_call(:next_sequence, _from, state) do
    #Logger.debug "#{inspect state}"
    case state do
      {0,_} -> { :reply, nil, nil }
      {a,b} -> { :reply, state, {a-1,b} }
      _ -> { :reply, nil, nil }
    end
  end

end
