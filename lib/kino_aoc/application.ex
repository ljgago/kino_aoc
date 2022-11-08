defmodule KinoAOC.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoAOC.HelperCell)

    children = []
    opts = [strategy: :one_for_one, name: KinoAOC.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
