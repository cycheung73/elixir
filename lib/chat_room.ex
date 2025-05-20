defmodule ChatRoom do
  use Application

  @moduledoc """
  Documentation for `ChatRoom`.
  """

  def start() do
    start(nil, nil)
  end

  @impl true
  def start(_type, _args) do
    children = [
      {ChatRoom.Supervisor, [name: ChatRoom.Supervisor]},
      {Registry, [keys: :unique, name: ChatRoom.Registry]},
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
