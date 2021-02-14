defmodule Paapi5 do
  @moduledoc """
  Documentation for `Paapi5`.
  """
  alias Paapi5.{Marketplace, Request}

  @service "ProductAdvertisingAPI"
  @http_method "POST"
  @content_type_header {"content-type", "application/json; charset=UTF-8"}

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

  def request(access_key, secret_key, partner_tag, marketplace, operation, payload, request_time \\ current_time())

  def request(access_key, secret_key, partner_tag, marketplace, operation, payload, request_time)
      when is_atom(marketplace) do
    request(access_key, secret_key, partner_tag, Marketplace.of(marketplace), operation, payload, request_time)
  end

  def request(access_key, secret_key, partner_tag, marketplace, operation, payload, request_time) do
    url = url_for(marketplace, operation)

    encoded_payload =
      payload_for(payload, partner_tag, operation)
      |> Jason.encode!()

    signed_header =
      Paapi5.Auth.sign(
        access_key,
        secret_key,
        @http_method,
        url,
        marketplace.region,
        @service,
        encoded_payload,
        headers_to_sign_for(operation),
        request_time
      )

    headers = [@content_type_header | signed_header]

    %Request{
      method: @http_method,
      url: url,
      body: encoded_payload,
      headers: headers
    }
  end

  defp url_for(marketplace, operation), do: "https://#{marketplace.host}/paapi5/#{String.downcase(operation)}"

  defp headers_to_sign_for(operation) do
    %{
      "x-amz-target" => "com.amazon.paapi5.v1.ProductAdvertisingAPIv1.#{operation}",
      "content-encoding" => "amz-1.0"
    }
  end

  defp payload_for(payload, partner_tag, operation) do
    payload
    |> Map.put("PartnerTag", partner_tag)
    |> Map.put("PartnerType", "Associates")
    |> Map.put("Operation", operation)
  end

  defp current_time, do: DateTime.utc_now() |> DateTime.to_naive()
end
