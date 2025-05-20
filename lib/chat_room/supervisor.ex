defmodule ChatRoom.Supervisor do
  use DynamicSupervisor

  def start_link(opts) do
    DynamicSupervisor.start_link(ChatRoom.Supervisor, :ok, opts)
  end

  def start_child(name) do
    child_specification = {ChatRoom.Room, name}

    DynamicSupervisor.start_child(ChatRoom.Supervisor, child_specification)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
