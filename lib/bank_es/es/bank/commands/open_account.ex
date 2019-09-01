defmodule BankEs.Commands.OpenBankAccount do
  defstruct [:account_number, :initial_balance]

  def new(account_number) do
    struct!(__MODULE__, account_number: account_number, initial_balance: 0)
  end
end
