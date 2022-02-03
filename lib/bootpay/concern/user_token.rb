module Bootpay::Concern::UserToken
  extend ActiveSupport::Concern

  included do
    # User Token 정보를 가져온다
    # Comment by Gosomi
    # Date: 2022-02-03
    def request_user_token(user_id:, email: nil, name: nil, gender: -1, birth: nil, phone: nil)
      request(
        method:  :post,
        uri:     'request/user/token',
        payload: {
          user_id: user_id,
          email:   email,
          name:    name,
          gender:  gender,
          birth:   birth,
          phone:   phone
        }
      )
    end
  end
end