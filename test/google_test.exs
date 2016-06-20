ExUnit.start

defmodule Google.RealClient.Test do
  use ExUnit.Case, async: true

  import Google.RealClient

  test "generate params with destiny" do
    expected_google_key = "google_key"
    expected_destination = "1,2"

    System.put_env "GOOGLE_APIKEY", expected_google_key

    params = params(expected_destination)

    assert params.origin == Application.get_env(:properties, :origin)
    assert params.destination == expected_destination
    assert params.key == expected_google_key
  end
end

defmodule Google.Test do
  use ExUnit.Case, async: true

  import Google

  test "ask Google for commute time" do
    assert commute_time(1, 2) == 3077
  end
end
