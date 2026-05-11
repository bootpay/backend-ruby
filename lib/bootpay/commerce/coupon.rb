# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class CouponModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 사용자 보유 쿠폰 목록
      def list(params = {})
        query_params = {}
        query_params[:status] = params[:status] if params[:status]
        query_params[:page]   = params[:page]   unless params[:page].nil?
        query_params[:limit]  = params[:limit]  unless params[:limit].nil?

        query = build_query(query_params)
        @bootpay.get("coupon#{query}")
      end

      # 다운로드 가능한 쿠폰 목록
      def available
        @bootpay.get('coupon/available')
      end

      # 쿠폰 다운로드 (issue_from_template)
      def download(params)
        @bootpay.post('coupon/download', params)
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
