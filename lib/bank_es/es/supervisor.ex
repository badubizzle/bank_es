defmodule BankEs.BankSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    children = [
      worker(
        Commanded.ProcessManagers.ProcessRouter,
        ["TransferProcessManager", BankEs.TransferMoneyProcessManager, BankEs.ApplicationRouter],
        restart: :permanent
      ),
      worker(BankEs.Projections.Account, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
