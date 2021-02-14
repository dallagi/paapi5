defmodule Paapi5.Marketplace do
  @moduledoc false

  @type t() :: %__MODULE__{host: String.t(), region: String.t()}
  @enforce_keys [:host, :region]
  defstruct [:host, :region]

  # source: https://webservices.amazon.com/paapi5/documentation/common-request-parameters.html#host-and-region
  @known_marketplaces [
    {:au, "webservices.amazon.com.au", "us-west-2"},
    {:br, "webservices.amazon.com.br", "us-east-1"},
    {:ca, "webservices.amazon.ca", "us-east-1"},
    {:fr, "webservices.amazon.fr", "eu-west-1"},
    {:de, "webservices.amazon.de", "eu-west-1"},
    {:in, "webservices.amazon.in", "eu-west-1"},
    {:it, "webservices.amazon.it", "eu-west-1"},
    {:jp, "webservices.amazon.co.jp", "us-west-2"},
    {:mx, "webservices.amazon.com.mx", "us-east-1"},
    {:nl, "webservices.amazon.nl", "eu-west-1"},
    {:sg, "webservices.amazon.sg", "us-west-2"},
    {:sa, "webservices.amazon.sa", "eu-west-1"},
    {:es, "webservices.amazon.es", "eu-west-1"},
    {:se, "webservices.amazon.se", "eu-west-1"},
    {:tr, "webservices.amazon.com.tr", "eu-west-1"},
    {:ae, "webservices.amazon.ae", "eu-west-1"},
    {:uk, "webservices.amazon.co.uk", "eu-west-1"},
    {:us, "webservices.amazon.com", "us-east-1"}
  ]

  @spec of(atom()) :: Paapi5.Marketplace.t() | nil
  def of(marketplace_id) do
    case known_marketplace_by(marketplace_id) do
      {_id, host, region} -> %__MODULE__{host: host, region: region}
      nil -> nil
    end
  end

  defp known_marketplace_by(marketplace_id) do
    List.keyfind(@known_marketplaces, marketplace_id, 0)
  end
end
