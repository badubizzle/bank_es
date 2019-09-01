defmodule BankEs.Commands.TransferMoney do
  defstruct [
    :account_number,
    :transfer_uuid,
    :to_account_number,
    :amount
  ]
end
