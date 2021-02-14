defmodule Paapi5 do
  @moduledoc """
  Documentation for `Paapi5`.
  """
  alias Paapi5.Marketplace

  @service "ProductAdvertisingAPI"

  @spec request(String.t(), String.t(), String.t(), atom | Marketplace.t(), String.t(), map) ::
          Request.t()
  def request(access_key, secret_key, partner_tag, marketplace, operation, payload)
      when is_atom(marketplace) do
    request(
      access_key,
      secret_key,
      partner_tag,
      Marketplace.of(marketplace),
      operation,
      payload
    )
  end

  def request(access_key, secret_key, partner_tag, marketplace, operation, payload) do
    endpoint = "https://#{marketplace.host}/paapi5/searchitems"

    headers = %{
      "x-amz-target" => "com.amazon.paapi5.v1.ProductAdvertisingAPIv1.SearchItems",
      "content-encoding" => "amz-1.0"
    }

    payload =
      %{
        "PartnerTag" => partner_tag,
        "PartnerType" => "Associates",
        "Operation" => operation
      }
      |> Map.merge(payload)

    current_time = DateTime.utc_now() |> DateTime.to_naive()
    encoded_payload = Jason.encode!(payload)

    signed_header =
      Paapi5.Auth.sign(
        access_key,
        secret_key,
        "POST",
        endpoint,
        marketplace.region,
        @service,
        encoded_payload,
        headers,
        current_time
      )

    headers = [{"content-type", "application/json; charset=UTF-8"} | signed_header]

    %Request{
      method: "POST",
      url: endpoint,
      body: encoded_payload,
      headers: headers
    }
  end
end
