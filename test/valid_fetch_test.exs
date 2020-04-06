defmodule ValidFetchTest do
  use ExUnit.Case
  doctest ValidFetch

  test "fetch/3 returns {:ok, value} given a valid map/kw and a key" do
    assert ValidFetch.fetch([hej: "test"], :hej, :binary) == {:ok, "test"}
    assert ValidFetch.fetch(%{"hej" => "test"}, "hej", :binary) == {:ok, "test"}
    assert ValidFetch.fetch(%{hej: "test"}, :hej, :binary) == {:ok, "test"}
  end
end
