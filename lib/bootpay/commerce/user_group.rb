# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class UserGroupModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 사용자 그룹 생성
      def create(user_group)
        @bootpay.post('user-groups', user_group)
      end

      # 사용자 그룹 목록 조회
      def list(params = {})
        query_params = {}
        query_params[:page]           = params[:page]           unless params[:page].nil?
        query_params[:limit]          = params[:limit]          unless params[:limit].nil?
        query_params[:keyword]        = params[:keyword]        if params[:keyword]
        query_params[:corporate_type] = params[:corporate_type] unless params[:corporate_type].nil?

        query = build_query(query_params)
        @bootpay.get("user-groups#{query}")
      end

      # 사용자 그룹 상세 조회
      def detail(user_group_id)
        @bootpay.get("user-groups/#{user_group_id}")
      end

      # 사용자 그룹 수정
      def update(user_group)
        raise ArgumentError, 'user_group_id is required' unless user_group[:user_group_id]
        @bootpay.put("user-groups/#{user_group[:user_group_id]}", user_group)
      end

      # 그룹에 사용자 추가
      def user_create(user_group_id, user_id)
        @bootpay.post("user-groups/#{user_group_id}/add_user", { user_id: user_id })
      end

      # 그룹에서 사용자 제거
      def user_delete(user_group_id, user_id)
        @bootpay.delete("user-groups/#{user_group_id}/remove_user?user_id=#{user_id}")
      end

      # 그룹 제한 설정
      def limit(params)
        raise ArgumentError, 'user_group_id is required' unless params[:user_group_id]
        @bootpay.put("user-groups/#{params[:user_group_id]}/limit", params)
      end

      # 그룹 거래 집계
      def aggregate_transaction(params)
        raise ArgumentError, 'user_group_id is required' unless params[:user_group_id]
        @bootpay.put("user-groups/#{params[:user_group_id]}/aggregate-transaction", params)
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
