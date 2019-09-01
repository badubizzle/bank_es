defmodule BankEs.Repo do
  use Ecto.Repo,
    otp_app: :bank_es,
    adapter: Ecto.Adapters.Postgres
end
