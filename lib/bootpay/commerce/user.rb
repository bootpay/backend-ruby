# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class UserModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 사용자 토큰 발급
      def token(user_id)
        @bootpay.post('users/login/token', { user_id: user_id })
      end

      # 회원가입
      def join(user)
        @bootpay.post('users/join', user)
      end

      # 중복 체크
      def check_exist(key, value)
        encoded_value = URI.encode_www_form_component(value)
        @bootpay.get("users/join/#{key}?pk=#{encoded_value}")
      end

      # 본인인증 데이터 조회
      def authentication_data(stand_id)
        @bootpay.get("users/authenticate/#{stand_id}")
      end

      # 로그인
      def login(login_id, login_pw)
        @bootpay.post('users/login', { login_id: login_id, login_pw: login_pw })
      end

      # 사용자 목록 조회
      def list(params = {})
        query_params = {}
        query_params[:page]        = params[:page]        unless params[:page].nil?
        query_params[:limit]       = params[:limit]       unless params[:limit].nil?
        query_params[:keyword]     = params[:keyword]     if params[:keyword]
        query_params[:member_type] = params[:member_type] unless params[:member_type].nil?
        query_params[:type]        = params[:type]        if params[:type]

        query = build_query(query_params)
        @bootpay.get("users#{query}")
      end

      # 사용자 상세 조회
      def detail(user_id)
        @bootpay.get("users/#{user_id}")
      end

      # 사용자 정보 수정
      def update(user)
        raise ArgumentError, 'user_id is required' unless user[:user_id]
        @bootpay.put("users/#{user[:user_id]}", user)
      end

      # 사용자 삭제
      def delete(user_id)
        @bootpay.delete("users/#{user_id}")
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
