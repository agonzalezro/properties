defmodule Google.RealClient do

  @url "https://maps.googleapis.com/maps/api/directions/json"

  def params(destination) do
    %{
      origin: Application.get_env(:properties, :origin),
      destination: destination,
      mode: "transit",
      transit_mode: "subway",
      key: System.get_env "GOOGLE_APIKEY"
    }
  end

  def directions_to(destination) do
    HTTPotion.get("#{@url}?#{URI.encode_query params destination}").body
  end
end

defmodule Google.TestClient do
  def directions_to(_destination) do
    File.read! "test/fixtures/google_directions_200.json"
  end
end

defmodule Google do
  @client Application.get_env :properties, :client

  @moduledoc "Module to interact with Google Directions API."

  def commute_time(latitude, longitude) do
    destination = "#{latitude},#{longitude}"

    route = @client.directions_to(destination)
    |> Poison.decode!
    |> Map.get("routes") |> List.first

    # TODO: better way to do this?
    case route do
      nil -> -1
      _ -> route
      |> Map.get("legs") |> List.first
      |> get_in(["duration", "value"])
    end
  end
end
