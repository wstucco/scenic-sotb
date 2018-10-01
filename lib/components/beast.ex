defmodule Sotb.Component.Beast do
  use ScenicME.Component

  alias Scenic.Graph
  alias ScenicME.Asset

  import Scenic.Primitives, only: [{:rect, 3}, {:group, 3}, {:update_opts, 2}]
  import Sotb.Component.Helpers

  @assets 1..5
          |> Enum.map(fn i ->
            cnt = i |> to_string |> String.pad_leading(2, "0")
            path = Asset.image("sotb/beast/ani_beast_#{cnt}.png")
            {path, Asset.hash(path)}
          end)

  # --------------------------------------------------------
  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  # ----------------------------------------------------------------------------
  def init(_data, _opts, _parent) do
    graph =
      Graph.build()
      |> group(
        fn g ->
          g
          |> rect(
            {96, 156},
            id: :beast_sprite
          )
        end,
        translate: {720, 380}
      )
      |> push_graph()

    hashes =
      @assets
      |> Enum.map(fn asset ->
        load_assets(asset) |> elem(1)
      end)

    {:ok, %{graph: graph, hashes: hashes}}
  end

  def animation_frame(%{frame: frame}, %{graph: graph, hashes: [hash | t]} = state)
      when rem(frame, 5) == 0 do
    graph =
      graph
      |> Graph.modify(
        :beast_sprite,
        &update_opts(&1,
          fill: {:image, hash}
        )
      )
      |> push_graph()

    {:noreply, %{state | graph: graph, hashes: t ++ [hash]}}
  end

  def animation_frame(_scene_state, state), do: {:noreply, state}
end
