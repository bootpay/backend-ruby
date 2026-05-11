# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    # V1 OrderSubscription Request 조회/승인 모듈
    #
    # 본인 모드 (user role): project_id 없이 호출 → 본인 요청 목록/단건
    # 슈퍼바이저 모드 (supervisor role): project_id 포함 → 프로젝트 전체 + update (승인/거절)
    #
    # 구매자측 요청 생성 (pause/resume/termination 등) 은
    # `commerce.order_subscription.request_ing.*` 모듈을 사용한다.
    class OrderSubscriptionRequestModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 요청 목록 조회 (user / supervisor 공용)
      def list(params = {})
        query_params = {}
        query_params[:project_id]   = params[:project_id]   if params[:project_id]
        query_params[:page]         = params[:page]         unless params[:page].nil?
        query_params[:limit]        = params[:limit]        unless params[:limit].nil?
        query_params[:request_type] = params[:request_type] unless params[:request_type].nil?
        query_params[:status]       = params[:status]       unless params[:status].nil?
        query_params[:s_at]         = params[:s_at]         if params[:s_at]
        query_params[:e_at]         = params[:e_at]         if params[:e_at]
        query_params[:keyword]      = params[:keyword]      if params[:keyword]

        query = build_query(query_params)
        @bootpay.get("order-subscription-requests#{query}")
      end

      # 요청 단건 조회 (user / supervisor 공용)
      def detail(order_subscription_request_history_id, project_id: nil)
        query_params = {}
        query_params[:project_id] = project_id if project_id

        query = build_query(query_params)
        @bootpay.get("order-subscription-requests/#{order_subscription_request_history_id}#{query}")
      end

      # 요청 승인/거절 (supervisor 전용)
      def update(params)
        raise ArgumentError, 'order_subscription_request_history_id is required' unless params[:order_subscription_request_history_id]
        history_id = params[:order_subscription_request_history_id]
        body = params.reject { |k, _| k == :order_subscription_request_history_id }
        @bootpay.put("order-subscription-requests/#{history_id}", body)
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
