defmodule SOTB.Component.Helpers do
  alias Scenic.ViewPort
  alias SOTB.Component.{Sprite, HorizontalScroller}

  def viewport_size(pid) when is_pid(pid), do: viewport_size(pid |> ViewPort.info())

  def viewport_size({:ok, %ViewPort.Status{size: {width, height}}}) do
    {width, height}
  end

  def viewport_width(viewport) do
    {width, _} = viewport_size(viewport)
    width
  end

  def scale_to_viewport({sprite_width, sprite_height}, viewport) do
    {width, height} = viewport_size(viewport)
    scale_h = height / sprite_height
    scale_w = width / sprite_width
    {sprite_width, sprite_height, scale_w, scale_h}
  end

  def add_sprite(graph, data, opts \\ []) do
    graph
    |> Sprite.add_to_graph({:ok, data}, opts)
  end

  def add_horizontal_scroller(graph, data, opts \\ []) do
    graph
    |> HorizontalScroller.add_to_graph({:ok, data}, opts)
  end

  def load_assets({path, hash}) do
    Scenic.Cache.File.load(path, hash)
  end

  def load_assets(path) do
    Scenic.Cache.File.load(path, Scenic.Cache.Hash.file!(path, :sha))
  end
end
