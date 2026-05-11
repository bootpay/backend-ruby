# frozen_string_literal: true

module Bootpay
  module Commerce
    class CategoryModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 카테고리 트리 조회
      def list
        @bootpay.get('categories')
      end

      # 카테고리 단건 조회
      def detail(category_id)
        @bootpay.get("categories/#{category_id}")
      end

      # 카테고리 생성
      def create(params)
        @bootpay.post('categories', params)
      end

      # 카테고리 수정
      def update(params)
        raise ArgumentError, 'category_id is required' unless params[:category_id]
        category_id = params[:category_id]
        body = params.reject { |k, _| k == :category_id }
        @bootpay.put("categories/#{category_id}", body)
      end

      # 카테고리 삭제
      def destroy(category_id)
        @bootpay.delete("categories/#{category_id}")
      end
    end
  end
end
