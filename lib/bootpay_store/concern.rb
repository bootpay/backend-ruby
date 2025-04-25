module BootpayStore
  module Concern
    require_relative 'concern/payment'
    require_relative 'concern/rest'
    require_relative 'concern/supervisor'
    require_relative 'concern/token'
    require_relative 'concern/user'

    include Payment
    include Rest
    include Supervisor
    include Token
    include User
  end
end