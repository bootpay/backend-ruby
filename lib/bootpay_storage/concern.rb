module BootpayStorage
  module Concern
    require_relative 'concern/rest'
    require_relative 'concern/token'
    require_relative 'concern/image'
    include Rest
    include Image
    include Token
  end
end