module Bootpay
  class Response
    attr_reader :data

    def initialize(success = true, data = {})
      @success = success
      @data    = data
    end

    def success?
      @success
    end
  end
end