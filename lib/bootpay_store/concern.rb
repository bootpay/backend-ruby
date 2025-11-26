module BootpayStore
  module Concern
    require_relative 'concern/invoice'
    require_relative 'concern/order'
    require_relative 'concern/order_subscription'
    require_relative 'concern/payment'
    require_relative 'concern/product'
    require_relative 'concern/rest'
    require_relative 'concern/supervisor'
    require_relative 'concern/token'
    require_relative 'concern/user'
    require_relative 'concern/user_group'

    include Invoice
    include Order
    include OrderSubscription
    include Payment
    include Product
    include Rest
    include Supervisor
    include Token
    include User
    include UserGroup
  end
end