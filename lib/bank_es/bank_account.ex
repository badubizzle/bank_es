defmodule BankEs.BankAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bank_accounts" do
    field :account_number, :string
    field :balance, :integer
    timestamps()
  end

  def new(attrs) do
    %__MODULE__{}
    |> change(attrs)
  end

  @doc false
  def changeset(bank_account, attrs) do
    bank_account
    |> cast(attrs, [:account_number, :balance])
    |> validate_required([:account_number, :balance])
  end
end
