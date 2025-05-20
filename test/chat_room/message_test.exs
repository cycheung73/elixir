defmodule ChatRoom.MessageTest do
  use ExUnit.Case, async: true

  setup do
    date = ~U[2025-05-19 18:15:00.00Z]
    dstr =   "2025-05-19 18:15:00 UTC"
    %{date: date, dstr: dstr}
  end

  test "create new message", %{date: date, dstr: dstr} do
    user = "Chris"
    body = "Hello, World!"
    msg = %ChatRoom.Message{ChatRoom.Message.new(user, body) | date: date}
    assert ChatRoom.Message.to_string(msg) == "[#{dstr}] #{user}: #{body}"
  end

end
