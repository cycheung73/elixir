defmodule ChatRoom do
  use Application

  @moduledoc """
  Documentation for `ChatRoom`.
  """

  @impl true
  def start(_type, _args) do
    children = [
      {ChatRoom.Supervisor, [name: ChatRoom.Supervisor]},
      {Registry, [keys: :unique, name: ChatRoom.Registry]},
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def join(name, user) do
    ChatRoom.Room.join(name, user)
  end

  def leave(name, user) do
    ChatRoom.Room.leave(name, user)
  end

  def get_history(name, user) do
    ChatRoom.Room.get_history(name, user)
  end

  def send_message(name, user, message) do
    ChatRoom.Room.send_message(name, user, message)
  end

end
