defmodule BankEs.Events.BankAccountOpened do
  @derive Jason.Encoder
  defstruct [:account_number, :initial_balance]

  defimpl BankEs.EventString, for: __MODULE__ do
    def to_event_string(%{initial_balance: _balance}) do
      "Opening balance"
    end

    def for_statement(%{initial_balance: amount} = event) do
      {amount, to_event_string(event)}
    end
  end
end
