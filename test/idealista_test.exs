ExUnit.start

defmodule Property.Test do
  use ExUnit.Case, async: true

  import Property

  test "has_garage" do
    newProperty = fn a, b -> Property.new(parkingSpace: %{"hasParkingSpace" => a, "isParkingSpaceIncludedInPrice" => b}) end

    cases = [
      {newProperty.(false, false), false},
      {newProperty.(false, true), false},
      {newProperty.(true, false), false},
      {newProperty.(true, true), true}
    ]

    cases
    |> Enum.each(fn(case) -> assert has_garage(elem(case, 0)) == elem(case, 1) end)
  end
end

defmodule Idealista.Client.Test do
  use ExUnit.Case, async: true

  import Idealista.Client
  import Mock

  setup do
    System.put_env "IDEALISTA_APIKEY", "key"
    System.put_env "IDEALISTA_SECRET", "secret"
    {:ok, expected_credentials: "a2V5OnNlY3JldA=="}
  end

  test "headers are ok" do
    expected_bearer = "expected_bearer"
    assert auth_headers(expected_bearer)[:headers][:Authorization] == "Bearer #{expected_bearer}"
  end

  test "credentials get encoded", %{expected_credentials: expected_credentials} do
    assert credentials == expected_credentials
  end

  test "bearer generated", %{expected_credentials: expected_credentials}  do
    expected_access_token = "hey there, it works!"

    with_mock HTTPotion, [
      post: fn(_url, [headers: headers]) ->
      assert headers[:Authorization] == "Basic #{expected_credentials}"
      %HTTPotion.Response{status_code: 200, body: '{"access_token": "#{expected_access_token}"}'} end
    ] do
      assert auth == expected_access_token
    end
  end
end

defmodule Idealista.Test do
  use ExUnit.Case, async: true

  test "get properties" do
    assert length(Idealista.properties("some_bearer")) == 150
  end
end
