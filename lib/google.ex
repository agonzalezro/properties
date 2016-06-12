defmodule Google do

  @moduledoc "Module to interact with Google Directions API."

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

  def commute_time(latitude, longitude) do
    destination = "#{latitude},#{longitude}"

    route = HTTPotion.get("#{@url}?#{URI.encode_query params destination}").body
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
