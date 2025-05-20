defmodule ChatRoom.Room do
  use Agent, restart: :temporary

  @typedoc """
  Type that represents ChatRoom.Room struct with :name as String,
  users as MapSet of String, and messages as List of ChatRoom.Message.
  """
  @type t :: %__MODULE__{
    name: String.t(),
    users: MapSet.t(),
    messages: list(ChatRoom.Message.t()),
  }
  
  defstruct [
    name: "",
    users: MapSet.new(),
    messages: [],
  ]

  defp add_user(%ChatRoom.Room{name: name, users: users, messages: messages}, user) do
    %ChatRoom.Room{name: name, users: MapSet.put(users, user), messages: messages}
  end

  defp del_user(%ChatRoom.Room{name: name, users: users, messages: messages}, user) do
    %ChatRoom.Room{name: name, users: MapSet.delete(users, user), messages: messages}
  end

  defp add_message(%ChatRoom.Room{name: name, users: users, messages: messages}, message) do
    %ChatRoom.Room{name: name, users: users, messages: [message | messages]}
  end

  @doc """
  Starts a new room.
  """
  @spec start_link(String.t()) :: Agent.on_start() | {:error, :room_already_exists}
  def start_link(name) do
    room = get_room(name)
    if ({:error, :room_not_found} == room) do
      Agent.start_link(fn -> %ChatRoom.Room{name: name} end, name: {:via, Registry, {ChatRoom.Registry, name}})
    else
      {:error, :room_already_exists}
    end
  end

  # {:error, :room_not_found}
  # {:error, :not_in_room}
  # {:error, :already_joined}
  # {:error, :room_already_exists}

  @spec join(String.t(), String.t()) :: :ok | {:error, :room_not_found} | {:error, :already_joined}
  def join(name, user) do
    room = get_room(name)
    if ({:error, :room_not_found} == room) do
      room
    else
      if not in_room?(room, user) do
	Agent.update(room, &add_user(&1, user))
      else
	{:error, :already_joined}
      end
    end
  end

  @spec leave(String.t(), String.t()) :: :ok | {:error, :room_not_found} | {:error, :not_in_room}
  def leave(name, user) do
    room = get_room(name)
    if ({:error, :room_not_found} == room) do
      room
    else
      if in_room?(room, user) do
	Agent.update(room, &del_user(&1, user))
      else
	{:error, :not_in_room}
      end
    end
  end

  @spec get_history(String.t(), String.t()) :: :ok | {:error, :room_not_found} | {:error, :not_in_room}
  def get_history(name, user) do
    room = get_room(name)
    if ({:error, :room_not_found} == room) do
      room
    else
      if in_room?(room, user) do
	get_messages(room)
      else
	{:error, :not_in_room}
      end
    end
  end

  @spec send_message(String.t(), String.t(), String.t()) :: :ok | {:error, :room_not_found} | {:error, :not_in_room}
  def send_message(name, user, message) do
    room = get_room(name)
    if ({:error, :room_not_found} == room) do
      room
    else
      if in_room?(room, user) do
	Agent.update(room, &add_message(&1, ChatRoom.Message.new(user, message)))
      else
	{:error, :not_in_room}
      end
    end
  end

  defp get(room) do
    Agent.get(room, & &1)
  end

  # defp get_name(room) do
  #   %ChatRoom.Room{name: name, users: _users, messages: _messages} = get(room)
  #   name
  # end

  defp get_room(name) do
    room_list = Registry.lookup(ChatRoom.Registry, name)
    if (length(room_list) == 0) do
      {:error, :room_not_found}
    else
      elem(hd(room_list), 0)
    end
  end

  defp get_users(room) do
    %ChatRoom.Room{name: _name, users: users, messages: _messages} = get(room)
    users
  end

  defp get_messages(room) do
    %ChatRoom.Room{name: _name, users: _users, messages: messages} = get(room)
    messages
  end

  defp in_room?(room, user) do
    MapSet.member?(get_users(room),user)
  end

end
