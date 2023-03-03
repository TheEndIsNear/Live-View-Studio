defmodule LiveViewStudioWeb.PizzaOrdersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.PizzaOrders
  import Number.Currency

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [pizza_orders: []]}
  end

  def handle_params(params, _uri, socket) do
    sort_order = valid_sort_order(params)
    sort_by = valid_sort_by(params)

    options = %{sort_order: sort_order, sort_by: sort_by}

    socket =
      assign(socket,
        pizza_orders: PizzaOrders.list_pizza_orders(options),
        options: options
      )

    {:noreply, socket}
  end

  defp next_sort_order(:asc), do: :desc
  defp next_sort_order(:desc), do: :asc

  defp valid_sort_order(%{"sort_order" => sort_order}) when sort_order in ~w(:asc desc) do
    String.to_existing_atom(sort_order)
  end

  defp valid_sort_order(_), do: :asc

  defp valid_sort_by(%{"sort_by" => sort_by})
       when sort_by in ~w(id size style topping_1 topping_2 price) do
    String.to_existing_atom(sort_by)
  end

  defp valid_sort_by(_), do: :id

  defp sort_indicator(column, %{sort_by: sort_by, sort_order: sort_order})
       when column == sort_by do
    case sort_order do
      :asc -> "↑"
      :desc -> "↓"
    end
  end

  defp sort_indicator(_, _), do: ""

  attr :sort_order, :atom, required: true
  attr :sort_by, :atom, required: true
  slot :inner_block, required: true

  defp sort_link(assigns) do
    ~H"""
    <.link patch={
      ~p"/pizza-orders?#{%{sort_by: @sort_by, sort_order: next_sort_order(@sort_order)}}"
    }>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
