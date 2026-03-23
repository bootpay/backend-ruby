# frozen_string_literal: true

module Bootpay
  module Commerce
    class OrderSubscriptionAdjustmentModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 정기구독 조정 생성
      def create(order_subscription_id, adjustment)
        @bootpay.post("order_subscriptions/#{order_subscription_id}/adjustments", adjustment)
      end

      # 정기구독 조정 수정
      def update(params)
        raise ArgumentError, 'order_subscription_id is required' unless params[:order_subscription_id]
        @bootpay.put("order_subscriptions/#{params[:order_subscription_id]}/adjustments", params)
      end

      # 정기구독 조정 삭제
      def delete(order_subscription_id, order_subscription_adjustment_id)
        @bootpay.delete(
          "order_subscriptions/#{order_subscription_id}/adjustments?order_subscription_adjustment_id=#{order_subscription_adjustment_id}"
        )
      end
    end
  end
end
