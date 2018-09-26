defmodule MyApp.Component.Sprite do
  use Scenic.Component
  alias Scenic.ViewPort
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:rect, 3}, {:group, 3}]
  import MyApp.Component.Helpers

  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  def init({:ok, data}, opts) do
    {:ok, hash} = load_assets(data.path)
    {width, height, _scale} =
      data.size
      |> scale_to_viewport(opts[:viewport])

    graph = Graph.build()
      |> group(
        fn g ->
          g
          |> rect(
            {width, height},
            fill: {:image, hash},
            translate: {0, 0}
          )
        end,
        opts
      )
      |> push_graph()


    {:ok, graph}
  end
end
