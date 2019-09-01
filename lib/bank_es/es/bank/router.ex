defmodule BankEs.BankAccountRouter do
  use Commanded.Commands.Router

  middleware(BankEs.Middleware.CommandLogger)

  alias BankEs.Commands.{OpenBankAccount, WithdrawMoney, TransferMoney, DepositMoney}
  alias BankEs.Aggregates.BankAccount

  identify(BankAccount, by: :account_number)

  dispatch([OpenBankAccount, WithdrawMoney, TransferMoney, DepositMoney],
    to: BankAccount
  )
end
