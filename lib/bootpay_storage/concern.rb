module BootpayStorage
  module Concern
    require_relative 'concern/rest'
    require_relative 'concern/token'
    require_relative 'concern/image'
    require_relative 'concern/csv'
    include Rest
    include Image
    include Token
    include Csv
  end
end