defmodule BankEs.Projections.Account do
  use Commanded.Projections.Ecto,
    name: "BankEs.Projections.Account",
    consistency: :strong

  alias BankEs.Events

  project %Events.BankAccountOpened{} = evt do
    create_account(multi, evt.account_number, evt.initial_balance)
  end

  project %Events.MoneyWithdrawn{} = evt do
    update_account_balance(multi, evt.account_number, -1 * evt.amount)
  end

  project %Events.MoneyDeposited{} = evt do
    update_account_balance(multi, evt.account_number, evt.amount)
  end

  defp update_account_balance(multi, account_number, amount) do
    Ecto.Multi.insert(
      multi,
      :withdraw_account,
      %BankEs.BankAccount{account_number: account_number},
      conflict_target: :account_number,
      on_conflict: [
        inc: [
          balance: amount
        ]
      ]
    )
  end

  defp create_account(multi, account_number, balance) do
    changeset =
      BankEs.BankAccount.new(%{
        account_number: account_number,
        balance: balance
      })

    Ecto.Multi.insert(multi, :account, changeset)
  end
end
