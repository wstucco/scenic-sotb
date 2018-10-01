defmodule SOTB.Scene.Main do
  @moduledoc """
  Sample splash scene.

  This scene demonstrate a very simple animation and transition to another scene.

  It also shows how to load a static texture and paint it into a rectangle.
  """

  use SOTB.Scene
  alias Scenic.Graph

  alias SOTB.Component.{
    Airships,
    Beast,
    FPS,
    FPSMultiplier,
    ParallaxBackground,
    StaticBackground
  }

  import Scenic.Primitives, only: [{:group, 3}]

  @graph Graph.build()

  # --------------------------------------------------------
  def init({_first_scene, _opts}) do
    # Timer.start(2)

    # graph = 1
    graph =
      @graph
      |> group(
        fn g ->
          g
          |> StaticBackground.add_to_graph()
          |> Airships.add_to_graph()
          |> ParallaxBackground.add_to_graph()
          |> Beast.add_to_graph()
          |> FPS.add_to_graph(__MODULE__, t: {20, 700})
          |> FPSMultiplier.add_to_graph(__MODULE__, t: {20, 650})
        end,
        scale: 0.5
      )
      # |> Nav.add_to_graph(__MODULE__)
      |> push_graph

    {:ok, %{graph: graph}}
  end
end
