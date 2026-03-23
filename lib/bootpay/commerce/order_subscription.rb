# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    # 정기구독 진행 중 요청 모듈
    class OrderSubscriptionRequestIngModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 정기구독 일시정지
      def pause(params)
        @bootpay.post('order_subscriptions/requests/ing/pause', params)
      end

      # 정기구독 재개
      def resume(params)
        @bootpay.put('order_subscriptions/requests/ing/resume', params)
      end

      # 해지 수수료 계산
      def calculate_termination_fee(order_subscription_id: nil, order_number: nil)
        raise ArgumentError, 'order_subscription_id or order_number is required' if order_subscription_id.nil? && order_number.nil?

        query_params = {}
        if order_subscription_id
          query_params[:order_subscription_id] = order_subscription_id
        elsif order_number
          query_params[:order_number] = order_number
        end

        @bootpay.get("order_subscriptions/requests/ing/calculate_termination_fee?#{URI.encode_www_form(query_params)}")
      end

      # 주문번호로 해지 수수료 계산
      def calculate_termination_fee_by_order_number(order_number)
        calculate_termination_fee(order_number: order_number)
      end

      # 정기구독 해지
      def termination(params)
        @bootpay.post('order_subscriptions/requests/ing/termination', params)
      end
    end

    # 정기구독 모듈
    class OrderSubscriptionModule
      attr_reader :request_ing

      def initialize(bootpay)
        @bootpay     = bootpay
        @request_ing = OrderSubscriptionRequestIngModule.new(bootpay)
      end

      # 정기구독 목록 조회
      def list(params = {})
        query_params = {}
        query_params[:page]          = params[:page]          unless params[:page].nil?
        query_params[:limit]         = params[:limit]         unless params[:limit].nil?
        query_params[:keyword]       = params[:keyword]       if params[:keyword]
        query_params[:s_at]          = params[:s_at]          if params[:s_at]
        query_params[:e_at]          = params[:e_at]          if params[:e_at]
        query_params[:request_type]  = params[:request_type]  if params[:request_type]
        query_params[:user_group_id] = params[:user_group_id] if params[:user_group_id]
        query_params[:user_id]       = params[:user_id]       if params[:user_id]

        query = build_query(query_params)
        @bootpay.get("order_subscriptions#{query}")
      end

      # 정기구독 상세 조회
      def detail(order_subscription_id)
        @bootpay.get("order_subscriptions/#{order_subscription_id}")
      end

      # 정기구독 수정
      def update(params)
        raise ArgumentError, 'order_subscription_id is required' unless params[:order_subscription_id]
        @bootpay.put("order_subscriptions/#{params[:order_subscription_id]}", params)
      end

      # Supervisor: 정기구독 승인
      def supervisor_approve(order_subscription_id, params = {})
        @bootpay.put("order_subscriptions/#{order_subscription_id}/approve", params)
      end

      # Supervisor: 정기구독 거절
      def supervisor_reject(order_subscription_id, params = {})
        @bootpay.put("order_subscriptions/#{order_subscription_id}/reject", params)
      end

      # Supervisor: 정기구독 해지
      def supervisor_terminate(order_subscription_id, params = {})
        @bootpay.put("order_subscriptions/#{order_subscription_id}/terminate", params)
      end

      # Supervisor: 정기구독 일시정지
      def supervisor_pause(order_subscription_id, params)
        @bootpay.put("order_subscriptions/#{order_subscription_id}/pause", params)
      end

      # Supervisor: 정기구독 재개
      def supervisor_resume(order_subscription_id, params = {})
        @bootpay.put("order_subscriptions/#{order_subscription_id}/resume", params)
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
