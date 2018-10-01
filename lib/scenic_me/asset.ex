defmodule ScenicME.Asset do
  @base_path :code.priv_dir(:sotb)

  def asset(path) do
    Path.join(@base_path, path)
  end

  def image(path) do
    asset(Path.join(["static", "images", path]))
  end

  def hash(path) do
    Scenic.Cache.Hash.file!(path, :sha)
  end
end
