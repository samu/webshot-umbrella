defmodule Webapp.Snapshot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "snapshots" do
    field :name, :string
    field :data, :binary

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model |> cast(params, ["name", "data"], [])
  end
end
