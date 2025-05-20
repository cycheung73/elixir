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

  @spec join(String.t(), String.t()) :: :ok | {:error, :room_not_found} | {:error, :already_joined}
  def join(name, user) do
    ChatRoom.Room.join(name, user)
  end

  @spec leave(String.t(), String.t()) :: :ok | {:error, :room_not_found} | {:error, :not_in_room}
  def leave(name, user) do
    ChatRoom.Room.leave(name, user)
  end

  @spec get_history(String.t(), String.t()) :: :ok | {:error, :room_not_found} | {:error, :not_in_room}
  def get_history(name, user) do
    ChatRoom.Room.get_history(name, user)
  end

  @spec send_message(String.t(), String.t(), String.t()) :: :ok | {:error, :room_not_found} | {:error, :not_in_room}
  def send_message(name, user, message) do
    ChatRoom.Room.send_message(name, user, message)
  end

end
