defmodule MyApp.Component.StaticBackground do
  use Scenic.Component

  alias Scenic.ViewPort
  alias Scenic.Graph
  alias MyApp.Asset
  alias MyApp.Component.Sprite

  import MyApp.Component.Helpers

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
        path: Asset.image("sotb/sotb_bkg.png"),
        size: {786, 600}
      })
      |> add_sprite(%{
          path: Asset.image("sotb/sotb_moon.png"),
          size: {159, 159}
        },
        translate: {width - 300, 80}
      )
      |> push_graph()

    {:ok, graph}
  end
end
