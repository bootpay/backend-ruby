# frozen_string_literal: true

require 'uri'

module Bootpay
  module Commerce
    class InvoiceModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 청구서 목록 조회
      def list(params = {})
        query_params = {}
        query_params[:page]    = params[:page]    unless params[:page].nil?
        query_params[:limit]   = params[:limit]   unless params[:limit].nil?
        query_params[:keyword] = params[:keyword] if params[:keyword]

        query = build_query(query_params)
        @bootpay.get("invoices#{query}")
      end

      # 청구서 생성
      def create(invoice)
        @bootpay.post('invoices', invoice)
      end

      # 청구서 알림 발송
      def notify(invoice_id, send_types)
        @bootpay.post("invoices/#{invoice_id}/notify", { send_types: send_types })
      end

      # 청구서 상세 조회
      def detail(invoice_id)
        @bootpay.get("invoices/#{invoice_id}")
      end

      private

      def build_query(params)
        return '' if params.empty?
        "?#{URI.encode_www_form(params)}"
      end
    end
  end
end
