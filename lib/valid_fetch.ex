defmodule ValidFetch do
  @moduledoc """
  Documentation for ValidFetch.
  """

  @types ~w(atom binary bitstring boolean float function integer list map number pid port reference tuple)

  #defp check_type(value, type) when type in @types do
  #  Code.eval_string("is_#{type}(value)", value: value)
  #end

  for type <- @types do
    defp check_type(value, unquote(type)) do
      unquote(:"is_#{type}")(value)
    end
  end

  def validate_type(value, type) when is_atom(type), do: validate_type(value, "#{type}")

  def validate_type(value, type) do
    if check_type(value, type) do
      :ok
    else
      {:error, :invalid_value}
    end
  end

  defp __fetch(map, key) when is_map(map) do
    with :error <- Map.fetch(map, key) do
        {:error, :key_not_found}
    end
  end

  defp __fetch(kw, key) when is_list(kw) and is_atom(key) do
    with :error <- Keyword.fetch(kw, key) do
        {:error, :key_not_found}
    end
  end

  defp __fetch(kw, _key) when is_list(kw), do: {:error, :key_not_found}

  @doc """
  Fetch a key from a map or Keyword list and check that it is a valid type

  ## Examples

      iex> ValidFetch.fetch([hej: "test"], :hej, :binary)
      {:ok, "test"}

      iex> ValidFetch.fetch(%{ hej: "test" }, :hej, :binary)
      {:ok, "test"}

      iex> ValidFetch.fetch(%{ "hej" => "test"}, "hej", :binary)
      {:ok, "test"}

  """
  def fetch(kw_or_map, key, type)  do
    with {:ok, value} <- __fetch(kw_or_map, key),
         :ok <- validate_type(value, type) do
      {:ok, value}
    end
  end
end
