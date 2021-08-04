defmodule Paapi5.Auth do
  @moduledoc false

  # credo:disable-for-next-line Credo.Check.Refactor.FunctionArity
  def sign(
        access_key,
        secret_key,
        http_method,
        url,
        region,
        service,
        payload,
        headers,
        request_time
      ) do
    uri = URI.parse(url)

    params = URI.decode_query(uri.query || "")

    headers = Map.put_new(headers, "host", uri.host)

    payload = hash_sha256(payload)

    headers = Map.put_new(headers, "x-amz-content-sha256", payload)

    amz_date = request_time |> format_time()
    date = request_time |> format_date()

    headers = Map.put_new(headers, "x-amz-date", amz_date)

    scope = "#{date}/#{region}/#{service}/aws4_request"

    string_to_sign =
      build_canonical_request(
        http_method,
        uri.path || "/",
        params,
        headers,
        payload
      )
      |> build_string_to_sign(amz_date, scope)

    signature =
      build_signing_key(secret_key, date, region, service)
      |> build_signature(string_to_sign)

    signed_headers =
      Enum.map(headers, fn {key, _} -> String.downcase(key) end)
      |> Enum.sort(&(&1 < &2))
      |> Enum.join(";")

    auth_header =
      "AWS4-HMAC-SHA256 " <>
        "Credential=#{access_key}/#{scope}," <>
        "SignedHeaders=#{signed_headers}," <>
        "Signature=#{signature}"

    headers
    |> Map.put("authorization", auth_header)
    |> Map.to_list()
  end

  defp build_canonical_request(http_method, path, params, headers, hashed_payload) do
    query_params = URI.encode_query(params) |> String.replace("+", "%20")

    header_params =
      Enum.map(headers, fn {key, value} -> "#{String.downcase(key)}:#{String.trim(value)}" end)
      |> Enum.sort(&(&1 < &2))
      |> Enum.join("\n")

    signed_header_params =
      Enum.map(headers, fn {key, _} -> String.downcase(key) end)
      |> Enum.sort(&(&1 < &2))
      |> Enum.join(";")

    encoded_path =
      path
      |> String.split("/")
      |> Enum.map(fn segment -> URI.encode_www_form(segment) end)
      |> Enum.join("/")

    "#{http_method}\n#{encoded_path}\n#{query_params}\n#{header_params}" <>
      "\n\n#{signed_header_params}\n#{hashed_payload}"
  end

  defp build_string_to_sign(canonical_request, timestamp, scope) do
    hashed_canonical_request = hash_sha256(canonical_request)
    "AWS4-HMAC-SHA256\n#{timestamp}\n#{scope}\n#{hashed_canonical_request}"
  end

  defp build_signing_key(secret_key, date, region, service) do
    hmac_sha256("AWS4#{secret_key}", date)
    |> hmac_sha256(region)
    |> hmac_sha256(service)
    |> hmac_sha256("aws4_request")
  end

  defp build_signature(signing_key, string_to_sign) do
    hmac_sha256(signing_key, string_to_sign)
    |> bytes_to_string
  end

  def hash_sha256(data) do
    :crypto.hash(:sha256, data)
    |> bytes_to_string
  end

  def hmac_sha256(key, data) do
    :crypto.mac(:hmac, :sha256, key, data)
  end

  def bytes_to_string(bytes) do
    Base.encode16(bytes, case: :lower)
  end

  defp format_time(time) do
    formatted_time =
      time
      |> NaiveDateTime.to_iso8601()
      |> String.split(".")
      |> List.first()
      |> String.replace("-", "")
      |> String.replace(":", "")

    formatted_time <> "Z"
  end

  defp format_date(date) do
    date
    |> NaiveDateTime.to_date()
    |> Date.to_iso8601()
    |> String.replace("-", "")
  end
end
