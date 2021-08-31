module Bootpay::Easy
  extend ActiveSupport::Concern

  included do
    # 회원 Token을 요청한다
    # Comment by ehowlsla
    # Date: 2021-08-230

    def get_user_token(user_id: nil, email: nil, name: nil, gender: nil, birth: nil, phone: nil)
      raise 'user_id 값을 입력해주세요.' if user_id.blank?

      request(
        uri: 'request/user/token',
        payload: {
          user_id: user_id,
          email: email,
          name: name,
          gender: gender,
          birth: birth,
          phone: phone
        }.compact
      )
    end
  end
end