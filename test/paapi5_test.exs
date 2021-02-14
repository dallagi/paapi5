defmodule Paapi5Test do
  use ExUnit.Case

  @access_key System.get_env("ACCESS_KEY")
  @secret_key System.get_env("SECRET_KEY")
  @partner_tag System.get_env("PARTNER_TAG")

  test "builds valid request to perform operations on Amazon Product Advertising Api" do
    request =
      Paapi5.request(
        @access_key,
        @secret_key,
        @partner_tag,
        :it,
        "SearchItems",
        %{"Keywords" => "das kapital"}
      )

    response = HTTPoison.request!(request.method, request.url, request.body, request.headers)

    assert response.status_code == 200

    assert %{
             "SearchResult" => %{
               "Items" => [
                 %{"ASIN" => _asin, "DetailPageURL" => "https://www.amazon." <> _rest_url}
                 | _rest_items
               ]
             }
           } = response.body |> Jason.decode!()
  end

  test "accepts custom marketplaces" do
    marketplace = %Paapi5.Marketplace{host: "webservices.amazon.it", region: "eu-west-1"}

    request =
      Paapi5.request(
        @access_key,
        @secret_key,
        @partner_tag,
        marketplace,
        "SearchItems",
        %{"Keywords" => "das kapital"}
      )

    response = HTTPoison.request!(request.method, request.url, request.body, request.headers)

    assert response.status_code == 200
  end
end
