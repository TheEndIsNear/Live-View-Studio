defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.{Airports, Flights}

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        airport: "",
        flights: [],
        matches: %{},
        loading: false
      )

    {:ok, socket, temporary_assigns: [flights: []]}
  end

  def handle_event("search", %{"airport" => airport}, socket) do
    send(self(), {:run_search, airport})
    {:noreply, assign(socket, flights: [], airport: airport, loading: true)}
  end

  def handle_event("suggest", %{"airport" => prefix}, socket) do
    {:noreply, assign(socket, matches: Airports.suggest(prefix))}
  end

  def handle_info({:run_search, airport}, socket) do
    {:noreply,
     assign(socket, flights: Flights.search_by_airport(airport), loading: false, airport: "")}
  end
end
