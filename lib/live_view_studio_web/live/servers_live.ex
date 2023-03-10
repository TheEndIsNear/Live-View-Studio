defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: :mount)
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        coffees: 0
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _URI, socket) do
    server = Servers.get_server!(id)
    {:noreply, assign(socket, selected_server: server, page_title: "What's up #{server.name}")}
  end

  def handle_params(_params, _URI, socket) do
    {:noreply,
     assign(socket,
       selected_server: hd(socket.assigns.servers)
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Servers</h1>
    <div id="servers">
      <.sidebar
        servers={@servers}
        selected_server={@selected_server}
        coffees={@coffees}
      />
      <div class="main">
        <div class="wrapper">
          <.server selected_server={@selected_server} />
          <div class="links">
            <.link navigate={~p"/"}>
              Home
            </.link>
            <.link navigate={~p"/light"}>
              Adjust Lights
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("drink", _, socket) do
    {:noreply, update(socket, :coffees, &(&1 + 1))}
  end

  attr :servers, :list, required: true
  attr :selected_server, :map, required: true
  attr :coffees, :list, required: true

  defp sidebar(assigns) do
    ~H"""
    <div class="sidebar">
      <div class="nav">
        <.link
          :for={server <- @servers}
          patch={~p"/servers?#{[id: server]}"}
          class={if server == @selected_server, do: "selected"}
        >
          <span class={server.status}></span>
          <%= server.name %>
        </.link>
      </div>
      <div class="coffees">
        <button phx-click="drink">
          <img src="/images/coffee.svg" />
          <%= @coffees %>
        </button>
      </div>
    </div>
    """
  end

  attr :selected_server, :map, required: true

  defp server(assigns) do
    ~H"""
    <div class="server">
      <div class="header">
        <h2><%= @selected_server.name %></h2>
        <span class={@selected_server.status}>
          <%= @selected_server.status %>
        </span>
      </div>
      <div class="body">
        <div class="row">
          <span>
            <%= @selected_server.deploy_count %> deploys
          </span>
          <span>
            <%= @selected_server.size %> MB
          </span>
          <span>
            <%= @selected_server.framework %>
          </span>
        </div>
        <h3>Last Commit Message:</h3>
        <blockquote>
          <%= @selected_server.last_commit_message %>
        </blockquote>
      </div>
    </div>
    """
  end
end
