module Bootpay
  module Concern
    require_relative 'concern/authenticate'
    require_relative 'concern/cash_receipt'
    require_relative 'concern/easy'
    require_relative 'concern/escrow'
    require_relative 'concern/payment'
    require_relative 'concern/reseller'
    require_relative 'concern/rest'
    require_relative 'concern/sdk'
    require_relative 'concern/seller'
    require_relative 'concern/service'
    require_relative 'concern/subscription'
    require_relative 'concern/token'
    require_relative 'concern/user_token'
    require_relative 'concern/webhook'

    include Authenticate
    include CashReceipt
    include Easy
    include Escrow
    include Payment
    include Reseller
    include Rest
    include Sdk
    include Seller
    include Service
    include Subscription
    include Token
    include UserToken
    include Webhook
  end
end