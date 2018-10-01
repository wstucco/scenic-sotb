defmodule Sotb.Component.FPSMultiplier do
  use ScenicME.Component

  alias Scenic.Graph
  import Scenic.Primitives, only: [{:text, 3}]
  import Scenic.Components, only: [{:slider, 3}]

  @multipliers [1 / 8, 1 / 4, 1 / 2, 3 / 4, 1, 1.5, 2, 2.5, 3]

  # --------------------------------------------------------
  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  def init(_data, _opts, _parent) do
    graph =
      Graph.build(font: :roboto, font_size: 48)
      |> text("FPS mulitplier: 1", id: :fps_multiplier_text)
      |> slider({@multipliers, 1}, id: :fps_multiplier_slider, t: {0, 20})
      |> push_graph()

    {:ok, graph}
  end

  def filter_event({:value_changed, :fps_multiplier_slider, multiplier}, _pid, graph) do
    text = ~s(FPS mulitplier: #{multiplier})

    graph =
      graph
      |> Graph.modify(:fps_multiplier_text, &text(&1, text, []))
      |> push_graph()

    send_event({:fps, 60 * multiplier})
    {:stop, graph}
  end
end
