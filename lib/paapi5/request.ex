defmodule Paapi5.Request do
  @type t() :: %__MODULE__{
          method: String.t(),
          url: String.t(),
          body: String.t(),
          headers: keyword()
        }
  defstruct [:method, :url, :body, :headers]
end
