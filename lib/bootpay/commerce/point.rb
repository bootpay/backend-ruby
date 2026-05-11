# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class PointModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 적립금 잔액 조회
      def balance
        @bootpay.get('point/balance')
      end

      # 적립금 내역 조회
      def transactions(params = {})
        query_params = {}
        query_params[:page]             = params[:page]             unless params[:page].nil?
        query_params[:limit]            = params[:limit]            unless params[:limit].nil?
        query_params[:transaction_type] = params[:transaction_type] unless params[:transaction_type].nil?

        query = build_query(query_params)
        @bootpay.get("point/transactions#{query}")
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
