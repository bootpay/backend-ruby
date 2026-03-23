# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class OrderCancelModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 취소 요청 목록 조회
      def list(params = {})
        query_params = {}
        query_params[:order_id]     = params[:order_id]     if params[:order_id]
        query_params[:order_number] = params[:order_number] if params[:order_number]

        query = build_query(query_params)
        @bootpay.get("order/cancel#{query}")
      end

      # 취소 요청
      def request(params)
        @bootpay.post('order/cancel', params)
      end

      # 취소 요청 철회
      def withdraw(order_cancel_request_history_id)
        @bootpay.put("order/cancel/#{order_cancel_request_history_id}/withdraw", {})
      end

      # 취소 승인
      def approve(params)
        raise ArgumentError, 'order_cancel_request_history_id is required' unless params[:order_cancel_request_history_id]
        @bootpay.put("order/cancel/#{params[:order_cancel_request_history_id]}/approve", params)
      end

      # 취소 거절
      def reject(params)
        raise ArgumentError, 'order_cancel_request_history_id is required' unless params[:order_cancel_request_history_id]
        @bootpay.put("order/cancel/#{params[:order_cancel_request_history_id]}/reject", params)
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
