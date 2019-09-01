defmodule BankEs.TransferMoneyProcessManager do
  use Commanded.ProcessManagers.ProcessManager,
    name: "TransferMoneyProcessManager",
    router: Dispatch.BankRouter,
    consistency: :strong

  alias BankEs.Events.{MoneyDeposited, MoneyTransferRequested, MoneyWithdrawn}
  alias BankEs.Commands.{WithdrawMoney, DepositMoney}
  alias __MODULE__

  @derive Jason.Encoder
  defstruct [
    :transfer_uuid,
    :debit_account,
    :credit_account,
    :amount,
    :status
  ]

  # Process routing

  def interested?(%MoneyTransferRequested{transfer_uuid: transfer_uuid} = _e) do
    {:start, transfer_uuid}
  end

  def interested?(%MoneyWithdrawn{transfer_uuid: transfer_uuid} = _e) do
    {:continue, transfer_uuid}
  end

  def interested?(%MoneyDeposited{transfer_uuid: transfer_uuid} = _e) do
    {:continue, transfer_uuid}
  end

  def interested?(_event), do: false

  # Command dispatch

  def handle(%TransferMoneyProcessManager{}, %MoneyTransferRequested{amount: amount} = event)
      when amount > 0 do
    %MoneyTransferRequested{
      transfer_uuid: transfer_uuid,
      credit_account: credit_account,
      debit_account: debit_account,
      amount: amount
    } = event

    [
      %WithdrawMoney{account_number: debit_account, transfer_uuid: transfer_uuid, amount: amount},
      %DepositMoney{account_number: credit_account, transfer_uuid: transfer_uuid, amount: amount}
    ]
  end
end
