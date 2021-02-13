defmodule Paapi5.MarketplaceTest do
  use ExUnit.Case
  alias Paapi5.Marketplace

  test "returns marketplace by id" do
    expected = %Marketplace{host: "webservices.amazon.it", region: "eu-west-1"}
    assert Marketplace.of(:it) == expected
  end

  test "returns nil when marketplace is unknown" do
    assert Marketplace.of(:unknown) == nil
  end
end
