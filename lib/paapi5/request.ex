defmodule Paapi5.Request do
  @moduledoc """
  A signed HTTP request for the Amazon Product Advertising API.
  """
  @type t() :: %__MODULE__{
          method: String.t(),
          url: String.t(),
          body: String.t(),
          headers: list({String.t(), String.t()})
        }
  defstruct [:method, :url, :body, :headers]
end
