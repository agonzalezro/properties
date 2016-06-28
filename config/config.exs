use Mix.Config

config :properties,

  filter_params: %{
    operation: "sale",
    propertyType: "homes",
    center: "40.4511,-3.6915",
    distance: 20_000,
    maxItems: 50,
    maxPrice: 230_000,
    minPrice: 100_000,
    sinceDate: "M",
    hasMultimedia: true,
    minSize: 90,
    flat: true,
    bedrooms: 3,
    bathrooms: 2,
    garage: true,
    sinceDate: "M"
  },

  # Jobandtalent office
  origin: "40.368401,-3.699586",

  # 40 minutes
  max_commute_time: 2400,

  # TODO: move to Google namespace or to google_client
  client: Google.RealClient,

  idealista_client: Idealista.Client

import_config "#{Mix.env}.exs"
