defmodule Paapi5 do
  @moduledoc """
  Documentation for `Paapi5`.
  """
  alias Paapi5.{Marketplace, Request}

  @service "ProductAdvertisingAPI"
  @current_time DateTime.utc_now() |> DateTime.to_naive()

  @spec request(
          String.t(),
          String.t(),
          String.t(),
          atom | Marketplace.t(),
          String.t(),
          map,
          NaiveDateTime.t()
        ) ::
          Request.t()

  def request(access_key, secret_key, partner_tag, marketplace, operation, payload, request_time \\ @current_time)

  def request(access_key, secret_key, partner_tag, marketplace, operation, payload, request_time)
      when is_atom(marketplace) do
    request(access_key, secret_key, partner_tag, Marketplace.of(marketplace), operation, payload, request_time)
  end

  def request(access_key, secret_key, partner_tag, marketplace, operation, payload, request_time) do
    endpoint = "https://#{marketplace.host}/paapi5/#{String.downcase(operation)}"

    headers = %{
      "x-amz-target" => "com.amazon.paapi5.v1.ProductAdvertisingAPIv1.#{operation}",
      "content-encoding" => "amz-1.0"
    }

    payload =
      Map.merge(
        payload,
        %{
          "PartnerTag" => partner_tag,
          "PartnerType" => "Associates",
          "Operation" => operation
        }
      )

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
        request_time
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
