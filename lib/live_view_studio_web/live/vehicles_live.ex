defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        vehicles: [],
        loading: false,
        matches: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>🚙 Find a Vehicle 🚘</h1>
    <div id="vehicles">
      <.filter_form phx-submit="search" phx-change="suggest" />
      <.datalist matches={@matches} />
      <.loading loading={@loading} />

      <div class="vehicles">
        <.vehicles vehicles={@vehicles} />
      </div>
    </div>
    """
  end

  def handle_event("search", %{"query" => query}, socket) do
    send(self(), {:search, query})
    {:noreply, assign(socket, loading: true)}
  end

  def handle_event("suggest", %{"query" => prefix}, socket) do
    {:noreply, assign(socket, matches: Vehicles.suggest(prefix))}
  end

  def handle_info({:search, query}, socket) do
    {:noreply, assign(socket, loading: false, vehicles: Vehicles.search(query))}
  end

  attr :rest, :global

  defp filter_form(assigns) do
    ~H"""
    <form {@rest}>
      <input
        type="text"
        name="query"
        value=""
        placeholder="Make or model"
        autofocus
        autocomplete="off"
        list="matches"
        phx-debounce="300"
      />

      <button>
        <img src="/images/search.svg" />
      </button>
    </form>
    """
  end

  attr :vehicles, :list, required: true

  defp vehicles(assigns) do
    ~H"""
    <ul>
      <li :for={vehicle <- @vehicles}>
        <span class="make-model">
          <%= vehicle.make_model %>
        </span>
        <span class="color">
          <%= vehicle.color %>
        </span>
        <span class={"status #{vehicle.status}"}>
          <%= vehicle.status %>
        </span>
      </li>
    </ul>
    """
  end

  attr :matches, :list, required: true

  defp datalist(assigns) do
    ~H"""
    <datalist id="matches">
      <option :for={match <- @matches} value={match}>
        <%= match %>
      </option>
    </datalist>
    """
  end
end
