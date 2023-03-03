defmodule LiveViewStudioWeb.DonationsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  def handle_params(params, _uri, socket) do
    sort_by = valid_sort_by(params)
    sort_order = valid_sort_order(params)

    options = %{sort_by: sort_by, sort_order: sort_order}

    donations = Donations.list_donations(options)

    {:noreply, assign(socket, donations: donations, options: options)}
  end

  defp next_sort_order(sort_order) do
    case sort_order do
      :asc -> :desc
      :desc -> :asc
    end
  end

  slot :inner_block, required: true
  attr :sort_by, :atom, required: true
  attr :options, :map, required: true

  defp sort_link(assigns) do
    ~H"""
    <.link patch={
      ~p"/donations?#{%{sort_by: @sort_by, sort_order: next_sort_order(@options.sort_order)}}"
    }>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp valid_sort_by(%{"sort_by" => sort_by})
       when sort_by in ~w(item quantity days_until_expires) do
    String.to_existing_atom(sort_by)
  end

  defp valid_sort_by(_), do: :id

  defp valid_sort_order(%{"sort_order" => sort_order}) when sort_order in ~w(asc desc) do
    String.to_existing_atom(sort_order)
  end

  defp valid_sort_order(_), do: :asc

  defp sort_indicator(column, %{sort_by: sort_by, sort_order: sort_order})
       when column == sort_by do
    case sort_order do
      :asc -> "👆"
      :desc -> "👇"
    end
  end

  defp sort_indicator(_, _), do: ""
end
