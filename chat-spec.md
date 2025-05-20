# GenServer Project: Multi-Room Chat System

## Project Summary

This project is to create a chat room system, where users can create named chat rooms (channels), join them, send messages, and view message history. Each chat room is managed by its own GenServer process. The goal is to learn how to use GenServers, dynamic supervision, and process registries to manage isolated, stateful services in Elixir.

## Core Requirements

### 1. Room Lifecycle

- Users can dynamically create named chat rooms.
- Each room has a unique name (e.g., "general", "games").
- Rooms are supervised using a `DynamicSupervisor`, so that a crash in one room doesn't crash the system.

### 2. Room Behavior

- Users must join a room before they can send messages.
- Users can leave a room at any time.
- Each room stores a message history (timestamp, sender, and body).
- Users can request the history of any room they’re in.

### 3. Process Naming

- Rooms should be identified using `via` tuples (through a Registry).
- Do not use a global map or ETS table; each room should be its own named process.

## Interaction: via IEx

The system should be fully usable from Elixir’s `iex` shell. For example:

```elixir
ChatRoom.Supervisor.start_chatroom("general")
ChatRoom.join("general", "Ellyse")
ChatRoom.send_message("general", "Ellyse", "Hello everyone!")
ChatRoom.get_history("general")
```

You do not need to build a web interface or command-line client. The focus is on building a clean and callable backend API.

## Expected Error Behaviors

Your code should return helpful errors rather than crashing in the following cases:

- Sending a message to a room that doesn’t exist  
  Return something like `{:error, :room_not_found}`.

- Sending a message before joining the room  
  Return something like `{:error, :not_in_room}`.

- Joining a room you're already in  
  Optional, but could return `{:error, :already_joined}`.

- Requesting history for a room that doesn’t exist  
  Return something like `{:error, :room_not_found}`.

- Attempting to start a room that already exists  
  Return `{:error, :room_already_exists}` or handle it idempotently.

## Typespecs and Dialyzer

Functions should have appropriate `@spec` annotations on public functions. The project should pass **Dialyzer** without warnings.

- Use `@spec` to document input and output types for each function.
- Include type definitions for your main data structures (e.g., messages, users).
- Note: no need to add typespec for behaviour calls (callbacks) in GenServer
- Avoid using `any()` or vague types unless absolutely necessary.
- Use `mix dialyzer` to check your types.
