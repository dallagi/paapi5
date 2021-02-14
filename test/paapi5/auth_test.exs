defmodule Paapi5.AuthTest do
  use ExUnit.Case, async: true
  @time ~N[2013-05-24 01:23:45]

  test "sign request correctly" do
    headers =
      Map.new()
      |> Map.put("Date", "Fri, 24 May 2013 00:00:00 GMT")
      |> Map.put("x-amz-target", "com.amazon.paapi5.v1.ProductAdvertisingAPIv1.SearchItems")
      |> Map.put("content-encoding", "amz-1.0")

    signed_request =
      Paapi5.Auth.sign(
        "AKIAIOSFODNN7EXAMPLE",
        "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
        "POST",
        "https://webservices.amazon.it/paapi5/searchitems",
        "eu-west-1",
        "ProductAdvertisingAPI",
        "{\"some\": \"payload\"}",
        headers,
        @time
      )

    {"authorization", "AWS4-HMAC-SHA256 " <> request_parts} = signed_request |> List.keyfind("authorization", 0)

    request_parts = String.split(request_parts, ",") |> Enum.map(&String.split(&1, "="))

    assert request_parts == [
             [
               "Credential",
               "AKIAIOSFODNN7EXAMPLE/20130524/eu-west-1/ProductAdvertisingAPI/aws4_request"
             ],
             [
               "SignedHeaders",
               "content-encoding;date;host;x-amz-content-sha256;x-amz-date;x-amz-target"
             ],
             ["Signature", "0d498722be0f482804e18f323971fc128e8f2430d64fbc4651a2085ebfce743e"]
           ]
  end
end
