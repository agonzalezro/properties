defmodule PropertiesTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  import Properties

  test "add commute time to the property struct" do
    assert add_commute_time(Property.new(%{})).commute_time == 3077
  end

  test "filter by parking" do
    assert filter_by_parking(Property.new(%{})) == false
  end

  test "filter by commute time" do
    p = %{Property.new(%{}) | commute_time: 1}
    assert filter_by_commute(p) == true

    p = %{p | commute_time: Application.get_env(:properties, :max_commute_time) + 1}
    assert filter_by_commute(p) == false
  end

  test "value extractor" do
    p = %{a: 1, b: 2}
    assert clean_property(p, [:a, :b]) == [1, 2]
  end

  test "csv exporter" do
    p = Property.new(address: "something")

    expected_lines = [
      "address,bathrooms,commute_time,floor,latitude,longitude,newDevelopment,price,priceByArea,propertyCode,rooms,size,thumbnail,url",
      "something,0,0,0,0.0,0.0,false,0,0,,0,0,,",
      ""
    ]

    assert capture_io(fn -> to_csv([p]) end) == expected_lines |> Enum.join("\n")
  end
end
