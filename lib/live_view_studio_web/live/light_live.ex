defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10, temperature: "3000")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background: #{temp_color(@temperature)}"}>
          <%= @brightness %>%
        </span>
      </div>
      <button phx-click="off">
        <img src="/images/light-off.svg" />
      </button>
      <button phx-click="down">
        <img src="/images/down.svg" alt="" />
      </button>
      <button phx-click="up">
        <img src="/images/up.svg" alt="" />
      </button>
      <button phx-click="on">
        <img src="/images/light-on.svg" />
      </button>
      <button phx-click="party">
        <img src="/images/fire.svg" />
      </button>

      <form phx-change="update">
        <input
          type="range"
          min="0"
          max="100"
          name="brightness"
          value={@brightness}
          phx-debounce="250"
        />
      </form>

      <div>
        <h2>Light Temperature Color</h2>
      </div>
      <form phx-change="color-update">
        <%= for temp <- ["3000", "4000", "5000"] do %>
          <input
            type="radio"
            id="temps"
            name="temp"
            value={temp}
            checked={@temperature == temp}
          />
          <label for={temp}><%= temp %></label>
        <% end %>
      </form>
    </div>
    """
  end

  def handle_event("off", _, socket) do
    {:noreply, assign(socket, brightness: 0)}
  end

  def handle_event("up", _, socket) do
    {:noreply, update(socket, :brightness, &min(100, &1 + 10))}
  end

  def handle_event("down", _, socket) do
    {:noreply, update(socket, :brightness, &max(0, &1 - 10))}
  end

  def handle_event("on", _, socket) do
    {:noreply, assign(socket, brightness: 100)}
  end

  def handle_event("party", _, socket) do
    {:noreply, assign(socket, brightness: Enum.random(0..100))}
  end

  def handle_event("update", %{"brightness" => brightness}, socket) do
    {:noreply, assign(socket, brightness: brightness)}
  end

  def handle_event("color-update", %{"temp" => temp}, socket) do
    {:noreply, assign(socket, temperature: temp)}
  end

  defp temp_color("3000"), do: "#F1C40D"
  defp temp_color("4000"), do: "#FEFF66"
  defp temp_color("5000"), do: "#99CCFF"
end
