defmodule {APP_NAME}Web.Example do
  @moduledoc false
  use {APP_NAME}Web, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :pagename, "main")
    socket = assign(socket, :count, 0)
    socket = assign(socket, :number, 0)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <.svelte name="Example" props={%{number: @number}} socket={@socket} />
    """
  end

  def handle_event("set_number", _, socket) do
    # IO.inspect(socket)
    number = socket.assigns.number + 1
    {:noreply, assign(socket, :number, number)}
  end
end
