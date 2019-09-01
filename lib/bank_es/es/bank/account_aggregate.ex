defmodule BankEs.Aggregates.BankAccount do
  @derive Jason.Encoder
  defstruct [:account_number, :balance]

  alias BankEs.Commands.{OpenBankAccount, WithdrawMoney, DepositMoney, TransferMoney}
  alias BankEs.Events.{BankAccountOpened, MoneyWithdrawn, MoneyDeposited, MoneyTransferRequested}
  alias __MODULE__

  def execute(
        %BankAccount{},
        %OpenBankAccount{account_number: account_number, initial_balance: initial_balance}
      )
      when is_binary(account_number) and initial_balance >= 0 do
    %BankAccountOpened{account_number: account_number, initial_balance: initial_balance}
  end

  def execute(%BankAccount{}, %OpenBankAccount{initial_balance: initial_balance})
      when initial_balance < 0 do
    {:error, :initial_balance_must_be_positive_integer}
  end

  def execute(%BankAccount{}, %OpenBankAccount{}) do
    {:error, :invalid_account}
  end

  def execute(
        %BankAccount{account_number: account_number, balance: balance},
        %TransferMoney{
          transfer_uuid: uuid,
          account_number: account_number,
          to_account_number: to_account_number,
          amount: amount
        }
      )
      when balance > 0 and balance > amount do
    %MoneyTransferRequested{
      transfer_uuid: uuid,
      debit_account: account_number,
      credit_account: to_account_number,
      amount: amount
    }
  end

  def execute(
        %BankAccount{balance: balance} = account,
        %WithdrawMoney{amount: amount}
      )
      when is_number(amount) and amount > 0 and balance > 0 and amount <= balance do
    %MoneyWithdrawn{
      account_number: account.account_number,
      amount: amount
    }
  end

  def execute(
        %BankAccount{balance: balance},
        %WithdrawMoney{amount: amount}
      )
      when amount > 0 and amount > balance do
    {:error, :insufficient_funds}
  end

  def execute(
        %BankAccount{},
        %WithdrawMoney{}
      ) do
    {:error, :invalid_withdrawal}
  end

  def execute(
        %BankAccount{account_number: account_number},
        %DepositMoney{account_number: account_number, amount: amount}
      )
      when amount > 0 do
    %MoneyDeposited{account_number: account_number, amount: amount}
  end

  def execute(
        %BankAccount{},
        %DepositMoney{}
      ) do
    {:error, :invalid_deposit}
  end

  def apply(%BankAccount{balance: balance} = state, %MoneyWithdrawn{amount: amount}) do
    %BankAccount{state | balance: balance - amount}
  end

  def apply(%BankAccount{balance: balance} = state, %MoneyDeposited{amount: amount}) do
    %BankAccount{state | balance: balance + amount}
  end

  def apply(
        %BankAccount{} = account,
        %BankAccountOpened{account_number: account_number, initial_balance: initial_balance}
      ) do
    %BankAccount{
      account
      | account_number: account_number,
        balance: initial_balance
    }
  end

  def apply(account, %MoneyTransferRequested{}) do
    account
  end
end
