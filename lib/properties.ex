defmodule Properties do

  @moduledoc "Grab Idealista properties, add some data to them and export them in CSV format."

  def main(_args) do
    Idealista.bearer
    |> Idealista.properties
    |> Enum.filter(&filter_by_parking/1)
    |> Enum.map(&add_commute_time/1)
    |> Enum.filter(&filter_by_commute/1)
    |> to_csv
  end

  # TODO: make it inline
  def filter_by_parking(property) do
    Property.has_garage(property)
  end

  # TODO: make it inline
  def add_commute_time(property) do
    %{property | commute_time: Google.commute_time(property.latitude, property.longitude)}
  end

  # TODO: make it inline
  def filter_by_commute(property) do
    time = property.commute_time
    time > 0 && time < Application.get_env(:properties, :max_commute_time)
  end

  def to_csv(properties) do
    keys = Map.keys(Property.__struct__)
    keys = keys
    |> List.delete(:__struct__)
    |> List.delete(:parkingSpace)

    IO.write CSVLixir.write_row(keys |> Enum.map(&Atom.to_string/1))
    properties
    |> Enum.each(&IO.write CSVLixir.write_row(clean_property(&1, keys)))
  end

  def clean_property(property, keys) do
    keys |> Enum.map(&Map.get(property, &1))
  end
end
