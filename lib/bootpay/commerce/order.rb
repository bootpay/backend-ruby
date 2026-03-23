# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class OrderModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 주문 목록 조회
      def list(params = {})
        query_params = {}
        query_params[:page]                     = params[:page]                     unless params[:page].nil?
        query_params[:limit]                    = params[:limit]                    unless params[:limit].nil?
        query_params[:keyword]                  = params[:keyword]                  if params[:keyword]
        query_params[:user_id]                  = params[:user_id]                  if params[:user_id]
        query_params[:user_group_id]            = params[:user_group_id]            if params[:user_group_id]
        query_params[:cs_type]                  = params[:cs_type]                  if params[:cs_type]
        query_params[:css_at]                   = params[:css_at]                   if params[:css_at]
        query_params[:cse_at]                   = params[:cse_at]                   if params[:cse_at]
        query_params[:subscription_billing_type] = params[:subscription_billing_type] unless params[:subscription_billing_type].nil?

        if params[:status].is_a?(Array) && !params[:status].empty?
          query_params[:status] = params[:status].map(&:to_s).join(',')
        end
        if params[:payment_status].is_a?(Array) && !params[:payment_status].empty?
          query_params[:payment_status] = params[:payment_status].map(&:to_s).join(',')
        end
        if params[:order_subscription_ids].is_a?(Array) && !params[:order_subscription_ids].empty?
          query_params[:order_subscription_ids] = params[:order_subscription_ids].join(',')
        end

        query = build_query(query_params)
        @bootpay.get("orders#{query}")
      end

      # 주문 상세 조회
      def detail(order_id)
        @bootpay.get("orders/#{order_id}")
      end

      # 월별 주문 조회
      def month(user_group_id, search_date)
        query_params = {
          user_group_id: user_group_id,
          search_date:   search_date
        }
        @bootpay.get("orders/month?#{URI.encode_www_form(query_params)}")
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
