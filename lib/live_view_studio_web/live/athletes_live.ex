defmodule LiveViewStudioWeb.AthletesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Athletes

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       filter: %{sport: "", status: ""},
       athletes: Athletes.list_athletes()
     ), temporary_assigns: [athletes: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Athletes</h1>
    <div id="athletes">
      <.filter_form filter={@filter} />

      <div class="athletes">
        <.athlete :for={athlete <- @athletes} athlete={athlete} />
      </div>
    </div>
    """
  end

  def handle_event("filter", %{"sport" => sport, "status" => status}, socket) do
    filter = %{sport: sport, status: status}
    {:noreply, assign(socket, filter: filter, athletes: Athletes.list_athletes(filter))}
  end

  attr :filter, :map, required: true

  defp filter_form(assigns) do
    ~H"""
    <form phx-change="filter">
      <div class="filters">
        <select name="sport">
          <%= Phoenix.HTML.Form.options_for_select(
            sport_options(),
            @filter.sport
          ) %>
        </select>
        <select name="status">
          <%= Phoenix.HTML.Form.options_for_select(
            status_options(),
            @filter.status
          ) %>
        </select>
      </div>
    </form>
    """
  end

  attr :athlete, :map, required: true

  defp athlete(assigns) do
    ~H"""
    <div class="emoji">
      <%= @athlete.emoji %>
    </div>
    <div class="name">
      <%= @athlete.name %>
    </div>
    <div class="details">
      <span class="sport">
        <%= @athlete.sport %>
      </span>
      <span class="status">
        <%= @athlete.status %>
      </span>
    </div>
    """
  end

  defp sport_options do
    [
      "All Sports": "",
      Surfing: "Surfing",
      Rowing: "Rowing",
      Swimming: "Swimming"
    ]
  end

  defp status_options do
    [
      "All Statuses": "",
      Training: :training,
      Competing: :competing,
      Resting: :resting
    ]
  end
end
