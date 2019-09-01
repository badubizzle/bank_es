defmodule BankEs.Repo.Migrations.CreateBankAccounts do
  use Ecto.Migration

  def change do
    create table(:bank_accounts) do
      add :account_number, :string
      add :balance, :integer

      timestamps()
    end

    create unique_index(:bank_accounts, :account_number)
  end
end
