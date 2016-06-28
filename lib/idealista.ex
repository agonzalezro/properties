defmodule Property do

  @moduledoc "Struct to shape the data of a property."

  defstruct propertyCode: "",
    address: "",
    bathrooms: 0,
    floor: 0,
    latitude: 0.0,
    longitude: 0.0,
    newDevelopment: false,
    price: 0,
    priceByArea: 0,
    rooms: 0,
    size: 0,
    thumbnail: "",
    url: "",
    parkingSpace: %{hasParkingSpace: false, isParkingSpaceIncludedInPrice: false},

    commute_time: 0

  use ExConstructor

  def has_garage(p) do
    p.parkingSpace[:hasParkingSpace] && p.parkingSpace[:isParkingSpaceIncludedInPrice]
  end
end


defmodule Idealista.Client do

  @auth_url "https://api.idealista.com/oauth/token"
  @search_url "https://api.idealista.com/3.5/es/search"

  @auth_params %{
    grant_type: "client_credentials",
    scope: "read"
  }

  def auth_headers(bearer) do
    [
      headers: ["Authorization": "Bearer #{bearer}"]
    ]
  end

  def credentials do
    # TODO: this should be part of app config
    # but I don't know how to fallback to env var from there
    apikey = System.get_env "IDEALISTA_APIKEY"
    secret = System.get_env "IDEALISTA_SECRET"
    encoded = Base.encode64("#{apikey}:#{secret}")
    unless apikey && secret do
      IO.puts "You must set IDEALISTA_APIKEY & IDEALISTA_SECRET"
      System.halt 1
    end
    encoded
  end

  def auth do
    resp = HTTPotion.post "#{@auth_url}?#{URI.encode_query @auth_params}", [
      headers: ["Authorization": "Basic #{credentials}",
                "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"]
    ]
    %{"access_token"=>bearer} = resp.body |> Poison.decode!
    bearer
  end

  def search(bearer, filter_params) do
    HTTPotion.post("#{@search_url}?#{URI.encode_query filter_params}", auth_headers(bearer)).body
  end
end

defmodule Idealista.FakeClient do

  def search(_bearer, _filter_params) do
    File.read! "test/fixtures/idealista_search_200.json"
  end
end

defmodule Idealista do

  @moduledoc "Module to interact with Idealist API."

  @client Application.get_env(:properties, :idealista_client)

  def bearer do
    @client.auth
  end

  def properties(bearer) do
    properties(bearer, 1, 0, [])
  end

  def properties(bearer, page, number_of_pages, acc) do
    case {bearer, page, number_of_pages, acc} do
      {_, _, _, acc} when number_of_pages > 0 and page + 1 > number_of_pages ->
        acc
      _ ->
        filter_params = Application.get_env(:properties, :filter_params)
        filter_params = filter_params |> Map.put(:numPage, page)

        %{"totalPages" => number_of_pages, "elementList" => raw_properties} =
          @client.search(bearer, filter_params)
          |> Poison.decode!

        raw_properties = properties(bearer, page + 1, number_of_pages, raw_properties ++ acc)
        raw_properties |> Enum.map(&Property.new/1)
    end
  end
end
