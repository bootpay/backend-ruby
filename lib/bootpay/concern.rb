module Bootpay
  module Concern
    require_relative 'concern/authenticate'
    require_relative 'concern/cash_receipt'
    require_relative 'concern/escrow'
    require_relative 'concern/payment'
    require_relative 'concern/rest'
    require_relative 'concern/subscription'
    require_relative 'concern/token'

    include Authenticate
    include CashReceipt
    include Escrow
    include Payment
    include Rest
    include Subscription
    include Token
  end
end