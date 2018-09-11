defmodule Sosc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    System.argv() |> parse_args |> process
  end

  @doc """
  'args' can be -h or help.
  Otherwise it is a N,k.
  Where N is maximum number from where the sequence can begin and K is the length of the sequence.
  """
  def parse_args(args) do
    parse =
      OptionParser.parse(args,
        strict: [n: :integer, k: :integer]
      )

    case parse do
      {[help: true], _, _} ->
        :help

      {_, [n, k], _} ->
        {String.to_integer(n), String.to_integer(k)}

      _ ->
        :help
    end
  end

  def process(:help) do
    IO.puts("""
    usage:  mix run proj1.exs <n> <k>
    Where n is maximum number from where the sequence can begin and k is the length of the sequence.
    """)

    System.halt(0)
  end

  @doc """
  Actual implementation of algorithm.
  """
  def process({n, k}) do
    #IO.puts("#{n} , #{k}")
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Sosc.Worker.start_link(arg)
      # {Sosc.Worker, arg},
      Sosc.Results,
      { Sosc.Sd,{n,k} },
      Sosc.WorkerSupervisor,
      {Sosc.CollectResults,8} #8 is number of workers
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sosc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
