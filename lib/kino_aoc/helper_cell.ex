defmodule KinoAOC.HelperCell do
  @moduledoc false

  use Kino.JS, assets_path: "lib/assets/helper_cell"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Advent of Code Helper"

  @impl true
  def init(attrs, ctx) do
    session = attrs["session"] || ""

    fields = %{
      "assign_to" => Kino.SmartCell.prefixed_var_name("puzzle_input", attrs["assign_to"]),
      "year" => attrs["year"] || "",
      "day" => attrs["day"] || "",
      "session" => session,
      "session_secret" => attrs["session_secret"] || "",
      "use_session_secret" => Map.has_key?(attrs, "session_secret") || session == ""
    }

    {:ok, assign(ctx, fields: fields)}
  end

  @impl true
  def handle_connect(ctx) do
    payload = %{
      fields: ctx.assigns.fields
    }

    {:ok, payload, ctx}
  end

  @impl true
  def to_attrs(%{assigns: %{fields: fields}}) do
    fields_keys =
      if fields["use_session_secret"],
        do: ~w|year day session_secret assign_to|,
        else: ~w|year day session assign_to|

    Map.take(fields, fields_keys)
  end

  @impl true
  def to_source(attrs) do
    quote do
      {:ok, unquote(quoted_var(attrs["assign_to"]))} =
        KinoAOC.download_puzzle(
          unquote(attrs["year"]),
          unquote(attrs["day"]),
          unquote(quoted_session(attrs))
        )
    end
    |> Kino.SmartCell.quoted_to_string()
  end

  defp quoted_var(string), do: {String.to_atom(string), [], nil}

  defp quoted_session(%{"session" => session}), do: session

  defp quoted_session(%{"session_secret" => ""}), do: ""

  defp quoted_session(%{"session_secret" => session_secret}) do
    quote do
      System.fetch_env!(unquote("LB_#{session_secret}"))
    end
  end

  @impl true
  def handle_event("update_field", %{"field" => field, "value" => value}, ctx) do
    updated_fields = to_updates(ctx.assigns.fields, field, value)
    ctx = update(ctx, :fields, &Map.merge(&1, updated_fields))
    broadcast_event(ctx, "update", %{"fields" => updated_fields})

    {:noreply, ctx}
  end

  defp to_updates(fields, "assign_to", value) do
    if Kino.SmartCell.valid_variable_name?(value) do
      %{"assign_to" => value}
    else
      %{"assign_to" => fields["assign_to"]}
    end
  end

  defp to_updates(_fields, field, value), do: %{field => value}
end
