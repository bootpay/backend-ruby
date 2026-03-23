# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class OrderSubscriptionBillModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 정기구독 청구 목록 조회
      def list(params = {})
        query_params = {}
        query_params[:page]                    = params[:page]                    unless params[:page].nil?
        query_params[:limit]                   = params[:limit]                   unless params[:limit].nil?
        query_params[:keyword]                 = params[:keyword]                 if params[:keyword]
        query_params[:order_subscription_id]   = params[:order_subscription_id]   if params[:order_subscription_id]

        if params[:status].is_a?(Array) && !params[:status].empty?
          query_params[:status] = params[:status].map(&:to_s).join(',')
        end

        query = build_query(query_params)
        @bootpay.get("order_subscription_bills#{query}")
      end

      # 정기구독 청구 상세 조회
      def detail(order_subscription_bill_id)
        @bootpay.get("order_subscription_bills/#{order_subscription_bill_id}")
      end

      # 정기구독 청구 수정
      def update(order_subscription_bill)
        raise ArgumentError, 'order_subscription_bill_id is required' unless order_subscription_bill[:order_subscription_bill_id]
        @bootpay.put(
          "order_subscription_bills/#{order_subscription_bill[:order_subscription_bill_id]}",
          order_subscription_bill
        )
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
