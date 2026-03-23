# frozen_string_literal: true

module Bootpay
  module Commerce
    class StoreModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 가맹점 기본 정보 조회
      def info
        @bootpay.get('store')
      end

      # 가맹점 상세 정보 조회
      def detail
        @bootpay.get('store/detail')
      end
    end
  end
end
