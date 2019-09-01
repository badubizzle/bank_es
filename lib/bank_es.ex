defmodule BankEs do
  @moduledoc """
  BankEs keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  import Ecto.Query
  alias BankEs.Commands
  alias BankEs.Events
  alias BankEs.BankAccount
  alias BankEs.ApplicationRouter

  alias BankEs.Repo
  alias EventStore.RecordedEvent
  alias TableRex
  alias TableRex.Table

  @spec get_account(binary()) :: BankAccount.t() | nil
  def get_account(account_number) when is_binary(account_number) do
    q = from acc in BankAccount, where: acc.account_number == ^account_number
    Repo.one(q)
  end

  def print_statement(account_number) do
    {:ok, transactions} =
      account_number
      |> EventStore.read_stream_forward()

    %{balance: closing_balance, rows: lines} =
      transactions
      |> Enum.reduce(%{balance: 0, rows: []}, fn %RecordedEvent{data: event},
                                                 %{balance: balance, rows: rows} ->
        {amount, description} = BankEs.EventString.for_statement(event)

        row =
          case amount >= 0 do
            true ->
              [description, "", "#{amount}"]

            _ ->
              [description, "#{amount}", ""]
          end

        %{balance: balance + amount, rows: [row | rows]}
      end)

    [["Closing balance", "", "#{closing_balance}"] | lines]
    |> Enum.reverse()
    |> Table.new(["Details", "Dr", "Cr"])
    |> Table.put_column_meta(1, color: :red)
    |> Table.put_column_meta(2, color: :green)
    # |> Table.put_cell_meta(0, Enum.count(lines), color: :green)
    |> Table.render!()
    |> IO.puts()
  end

  @spec deposit_money(binary, pos_integer) :: {:error, String.t()} | {:ok, BankEs.BankAccount.t()}
  def deposit_money(account_number, amount)
      when is_binary(account_number) and is_integer(amount) and amount > 0 do
    result =
      [account_number: account_number, amount: amount]
      |> Commands.DepositMoney.new()
      |> ApplicationRouter.dispatch(consistency: :strong)

    case result do
      :ok ->
        {:ok, get_account(account_number)}

      _ ->
        {:error, "Could not deposit money"}
    end
  end

  @spec withdraw_money(binary(), pos_integer()) ::
          {:error, String.t()} | {:ok, BankAccount.t()}
  def withdraw_money(account_number, amount)
      when is_binary(account_number) and is_integer(amount) and amount > 0 do
    params = [account_number: account_number, amount: amount]

    case params
         |> Commands.WithdrawMoney.new()
         |> ApplicationRouter.dispatch(consistency: :strong) do
      :ok ->
        {:ok, get_account(account_number)}

      _ ->
        {:error, "Could not withdraw money"}
    end
  end

  def create_account() do
    account_number = UUID.uuid4()

    r =
      account_number
      |> Commands.OpenBankAccount.new()
      |> ApplicationRouter.dispatch(consistency: :strong)

    case r do
      :ok ->
        {:ok, get_account(account_number)}

      {:ok, _} ->
        {:ok, get_account(account_number)}

      _ ->
        {:error, "Could not create account"}
    end
  end
end
