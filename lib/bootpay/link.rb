
# Comment by ehowlsla
# Date: 2021-08-31
# @return [Hash]
module Bootpay::Link
  extend ActiveSupport::Concern

  included do
    def request_link(pg: nil, method: nil, methods: nil, price: nil, order_id: nil, params: nil, tax_free: nil, name: nil,
                     user_info: {id: nil, username: nil, email: nil, phone: nil, gender: nil, area: nil, birth: nil},
                     items: nil,
                     extra: {
                       escrow: nil, # 에스크로 연동 시 true, 기본값 false
                       quota: nil, #List<int> 형태,  결제금액이 5만원 이상시 할부개월 허용범위를 설정할 수 있음, ex) "0,2,3" 지정시 - [0(일시불), 2개월, 3개월] 허용, 미설정시 PG사별 기본값 적용
                       disp_cash_result: nil, # 현금영수증 노출할지 말지 (가상계좌 이용시)
                       offer_period: nil, # 통합결제창, PG 정기결제창에서 표시되는 '월 자동결제'에 해당하는 문구를 지정한 값으로 변경, 지원하는 PG사만 적용 가능
                       theme: nil, # 통합결제창 테마, [ red, purple(기본), custom ] 중 택 1
                       custom_background: nil, # 통합결제창 배경색,  ex) "#00a086" theme가 custom 일 때 background 색상 지정 가능
                       custom_font_color: nil # 통합결제창 글자색,  ex) "#ffffff" theme가 custom 일 때 font color 색상 지정 가능
                     }
    )
      request(
        uri: 'request/payment',
        payload:
          {
            pg:               pg, # [PG 결제] 사용하고자 하는 PG사의 Alias를 입력. ex) danal, kcp, inicis등, 미 지정시 통합결제창이 오픈
            method:           method, # card:카드, phone: 휴대폰, bank: 실시간 계좌이체, vbank: 가상계좌, auth: 본인인증, card_rebill: 정기결제, easy: 카카오,페이코,네이버페이 등의 간편결제, 미지정시 통합결제창 오픈
            methods:          methods, # 통합결제시 사용할 method 배열 형태
            price:            price, # 결제금액
            order_id:         order_id, # 개발사에서 관리하는 고유결제번호
            params:           params, # string 형태로 전달 할 값, 결제 후 똑같이 리턴해드림
            tax_free:         tax_free, # 비과세 금액
            name:             name, # 결제할 상품명
            user_info:        user_info, # 구매자 정보
            items:            items, #  상품정보
            # return_url:       return_url, # 결제후 이동할 페이지 url, 아직 사용하지 않음
            extra:            extra.values.any? {|v|v != nil} ? extra : nil # 기타 옵션
          }.compact
      )
    end
  end
end