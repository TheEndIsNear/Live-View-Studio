defmodule LiveViewStudioWeb.SalesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok, assign_sales_data(socket)}
  end

  def handle_event("refresh", _, socket) do
    {:noreply, assign_sales_data(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, assign_sales_data(socket)}
  end

  defp assign_sales_data(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
