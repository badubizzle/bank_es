defmodule BankEs.Commands.WithdrawMoney do
  defstruct [:account_number, :amount, :transfer_uuid]

  def new(account_number: account_number, amount: amount)
      when is_integer(amount) and amount > 0 do
    struct!(__MODULE__, account_number: account_number, amount: amount)
  end
end
