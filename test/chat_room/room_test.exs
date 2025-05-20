defmodule ChatRoom.RoomTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, general} = ChatRoom.Room.start_link([name: "general"])
    {:ok, games} = ChatRoom.Room.start_link([name: "games"])
    user = "Chris"
    ChatRoom.Room.join(general, user)
    ChatRoom.Room.join(games, user)
    ChatRoom.Room.send_message(general, user, "Hello, World!")
    ChatRoom.Room.send_message(general, user, "Let's get started.")
    ChatRoom.Room.send_message(games, user, "What are we playing?")
    %{general: general, games: games}
  end

  test "chatroom (join, get_history, send_message, leave)", %{general: general, games: games} do
    user1 = "Chris"
    user2 = "Gabe"
    message = "Greetings, everyone."
    assert ChatRoom.Room.join(general, user2) == :ok
    [msg1, msg2] = ChatRoom.Room.get_history(general, user1)
    %ChatRoom.Message{date: _mesg_date1, user: mesg_user1, body: mesg_body1} = msg1
    %ChatRoom.Message{date: _mesg_date2, user: mesg_user2, body: mesg_body2} = msg2
    assert mesg_user1 == user1
    assert mesg_body1 == "Let's get started."
    assert mesg_user2 == user1
    assert mesg_body2 == "Hello, World!"
    assert ChatRoom.Room.send_message(general, user2, message) == :ok
    [msg3 | _] = ChatRoom.Room.get_history(general, user1)
    %ChatRoom.Message{date: _mesg_date3, user: mesg_user3, body: mesg_body3} = msg3
    assert mesg_user3 == user2
    assert mesg_body3 == message
    assert ChatRoom.Room.leave(general, user2) == :ok
    [msg4] = ChatRoom.Room.get_history(games, user1)
    %ChatRoom.Message{date: _mesg_date4, user: mesg_user4, body: mesg_body4} = msg4
    assert mesg_user4 == user1
    assert mesg_body4 == "What are we playing?"
  end

  test "chatroom errors (join, get_history, send_message, leave)", %{general: general, games: games} do
    user1 = "Chris"
    user2 = "Gabe"
    message = "Greetings, everyone."
    assert ChatRoom.Room.join(general, user1) == {:error, :already_joined}
    assert ChatRoom.Room.get_history(games, user2) == {:error, :not_in_room}
    assert ChatRoom.Room.send_message(games, user2, message) == {:error, :not_in_room}
    assert ChatRoom.Room.leave(games, user2) == {:error, :not_in_room}
  end

end
