# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class ProductModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 상품 목록 조회
      def list(params = {})
        query_params = {}
        query_params[:page]          = params[:page]          unless params[:page].nil?
        query_params[:limit]         = params[:limit]         unless params[:limit].nil?
        query_params[:keyword]       = params[:keyword]       if params[:keyword]
        query_params[:type]          = params[:type]          unless params[:type].nil?
        query_params[:period_type]   = params[:period_type]   if params[:period_type]
        query_params[:s_at]          = params[:s_at]          if params[:s_at]
        query_params[:e_at]          = params[:e_at]          if params[:e_at]
        query_params[:category_code] = params[:category_code] if params[:category_code]

        query = build_query(query_params)
        @bootpay.get("products#{query}")
      end

      # 상품 생성 (이미지 포함)
      def create(product, image_paths = nil)
        @bootpay.post_multipart('products', product, image_paths)
      end

      # 상품 상세 조회
      def detail(product_id)
        @bootpay.get("products/#{product_id}")
      end

      # 상품 수정
      def update(product)
        raise ArgumentError, 'product_id is required' unless product[:product_id]
        @bootpay.put("products/#{product[:product_id]}", product)
      end

      # 상품 상태 변경
      def status(params)
        raise ArgumentError, 'product_id is required' unless params[:product_id]
        @bootpay.put("products/#{params[:product_id]}/status", params)
      end

      # 상품 삭제
      def delete(product_id)
        @bootpay.delete("products/#{product_id}")
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
