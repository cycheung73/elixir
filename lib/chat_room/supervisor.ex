defmodule ChatRoom.Supervisor do
  use DynamicSupervisor

  @spec start_link([DynamicSupervisor.init_option() | GenServer.option()]) :: Supervisor.on_start()
  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, opts)
  end

  @spec start_chatroom(String.t()) :: DynamicSupervisor.on_start_child()
  def start_chatroom(name) do
    child_specification = {ChatRoom.Room, name}

    DynamicSupervisor.start_child(__MODULE__, child_specification)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
