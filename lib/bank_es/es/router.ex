defmodule BankEs.ApplicationRouter do
  use Commanded.Commands.CompositeRouter

  router(BankEs.BankAccountRouter)
end
