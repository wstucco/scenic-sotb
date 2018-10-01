defmodule SOTB.Component.StaticBackground do
  use Scenic.Component

  alias Scenic.Graph
  alias SOTB.Asset

  import SOTB.Component.Helpers

  @background {
    Asset.image("sotb/sotb_bkg.png"),
    Asset.hash(Asset.image("sotb/sotb_bkg.png"))
  }

  @moon {
    Asset.image("sotb/sotb_moon.png"),
    Asset.hash(Asset.image("sotb/sotb_moon.png"))
  }

  # --------------------------------------------------------
  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  # ----------------------------------------------------------------------------
  def init(_, opts) do
    {width, _} = viewport_size(opts[:viewport])

    graph =
      Graph.build()
      |> add_sprite(%{
        path: @background,
        size: {786, 600}
      })
      |> add_sprite(
        %{
          path: @background,
          size: {786, 600}
        },
        translate: {width, 0}
      )
      |> add_sprite(
        %{
          path: @moon,
          size: {159, 159}
        },
        translate: {width * 2 - 300, 80}
      )
      |> push_graph()

    {:ok, graph}
  end
end
