defmodule AppWeb.Components.BreadCrumb do
  use AppWeb, :component

  def get_breadcrumbs(assigns) do
    render(assigns)
  end

  defp render(assigns) do
    ~H"""
    <nav aria-label="breadcrumb">
      <ol class="breadcrumb">
        <%= for {path, item} <- @items do %>
        <li class="breadcrumb-item active" aria-current="page">
          <a href={path}><%= item %></a>
        </li>
        <% end %>
      </ol>
    </nav>
    """
  end
end