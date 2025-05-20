defmodule ChatRoom.Message do

  @typedoc """
  Type that represents ChatRoom.Message struct with :date as DateTime.utc_now(),
  :user as String, and :body as String.
  """

  @type t :: %__MODULE__{
    date: DateTime.t(), 
    user: String.t(), 
    body: String.t(),
  }

  defstruct [
    date: nil,
    user: "",
    body: "",
  ]

  @spec new(String.t(), String.t()) :: ChatRoom.Message.t()
  def new(user, body) when is_binary(user) and is_binary(body) do
    %ChatRoom.Message{date: DateTime.utc_now(), user: user, body: body}
  end

  @spec to_string(ChatRoom.Message.t()) :: String.t()
  def to_string(%ChatRoom.Message{date: date, user: user, body: body}) do
    Calendar.strftime(date, "[%Y-%m-%d %H:%M:%S UTC] #{user}: #{body}")
  end

end
