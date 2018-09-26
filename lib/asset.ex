defmodule MyApp.Asset do
  @base_path :code.priv_dir(:my_app)

  def asset(path) do
    Path.join(@base_path, path)
  end

  def image(path) do
    asset(Path.join(["static", "images", path]))
  end
end
