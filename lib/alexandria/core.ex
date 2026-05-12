defmodule Alexandria.Core do
  use Ash.Domain,
    otp_app: :alexandria,
    extensions: [Alexandria.FragmentExtension]

  resources do
  end
end
