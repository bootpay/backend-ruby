module BootpayStore::Concern::UserGroup
  extend ActiveSupport::Concern

  included do
    # 등록된 User Group 정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-06-18
    def user_groups(keyword: nil, page: 1, limit: 20, corporate_type: 2, idempotency_key: nil)
      request(
        uri:     'user-groups',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:
                 {
                   keyword:        keyword,
                   page:           page,
                   limit:          limit,
                   corporate_type: corporate_type
                 }.compact
      )
    end

    # user group 정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-06-18
    def lookup_user_group(user_group_id:, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 새로운 User Group을 생성한다
    # Comment by GOSOMI
    # @date: 2025-06-18
    def create_user_group(uid: nil, phone: nil, email: nil, address: nil, address_detail: nil, zipcode: nil,
                          corporate_type: nil, bank: nil, bank_code: nil, company_name: nil, business_number: nil,
                          registration_number: nil, business_type: nil, business_category: nil, ceo_name: nil, auth_company: nil,
                          manager_name: nil, manager_phone: nil, manager_email: nil, pccc: nil, use_subscription_aggregate_transaction: nil,
                          subscription_month_day: nil, subscription_week_day: nil, purchase_limit: nil, subscribed_limit: nil,
                          limit_message: nil, idempotency_key: nil)
      request(
        uri:     'user-groups',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload:
                 {
                   uid:                                    uid,
                   phone:                                  phone,
                   email:                                  email,
                   address:                                address,
                   address_detail:                         address_detail,
                   corporate_type:                         corporate_type,
                   bank:                                   bank,
                   bank_code:                              bank_code,
                   zipcode:                                zipcode,
                   company_name:                           company_name,
                   business_number:                        business_number,
                   registration_number:                    registration_number,
                   business_type:                          business_type,
                   business_category:                      business_category,
                   ceo_name:                               ceo_name,
                   auth_company:                           auth_company,
                   manager_name:                           manager_name,
                   manager_phone:                          manager_phone,
                   manager_email:                          manager_email,
                   pccc:                                   pccc,
                   use_subscription_aggregate_transaction: use_subscription_aggregate_transaction,
                   subscription_month_day:                 subscription_month_day,
                   subscription_week_day:                  subscription_week_day,
                   purchase_limit:                         purchase_limit,
                   subscribed_limit:                       subscribed_limit,
                   limit_message:                          limit_message
                 }.compact
      )
    end

    # UserGroup 정보를 갱신한다
    # Comment by GOSOMI
    # @date: 2025-06-18
    def update_user_group(user_group_id:, phone: nil, email: nil, address: nil, address_detail: nil, zipcode: nil,
                          corporate_type: nil, bank: nil, bank_code: nil, company_name: nil, business_number: nil,
                          registration_number: nil, business_type: nil, business_category: nil, ceo_name: nil, auth_company: nil,
                          manager_name: nil, manager_phone: nil, manager_email: nil, pccc: nil, use_subscription_aggregate_transaction: nil,
                          subscription_month_day: nil, subscription_week_day: nil, purchase_limit: nil, subscribed_limit: nil,
                          limit_message: nil, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload:
                 {
                   phone:                                  phone,
                   email:                                  email,
                   address:                                address,
                   address_detail:                         address_detail,
                   corporate_type:                         corporate_type,
                   bank:                                   bank,
                   bank_code:                              bank_code,
                   zipcode:                                zipcode,
                   company_name:                           company_name,
                   business_number:                        business_number,
                   registration_number:                    registration_number,
                   business_type:                          business_type,
                   business_category:                      business_category,
                   ceo_name:                               ceo_name,
                   auth_company:                           auth_company,
                   manager_name:                           manager_name,
                   manager_phone:                          manager_phone,
                   manager_email:                          manager_email,
                   pccc:                                   pccc,
                   use_subscription_aggregate_transaction: use_subscription_aggregate_transaction,
                   subscription_month_day:                 subscription_month_day,
                   subscription_week_day:                  subscription_week_day,
                   purchase_limit:                         purchase_limit,
                   subscribed_limit:                       subscribed_limit,
                   limit_message:                          limit_message
                 }.compact
      )
    end

    # UserGroup 정보를 삭제한다
    # Comment by GOSOMI
    # @date: 2025-06-19
    def delete_user_group(user_group_id:, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 사용자 그룹에 사용자를 추가한다
    def add_user_to_group(user_group_id:, user_id:, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}/user",
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        },
        payload: { user_id: user_id }
      )
    end

    # 사용자 그룹에서 사용자를 제거한다
    def delete_user_from_group(user_group_id:, user_id:, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}/user/#{user_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        }
      )
    end

    # 그룹 구매한도를 설정한다 (PUT /v1/user-groups/:id/limit)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # ⚠️ update_user_group 으로는 한도가 절대 반영되지 않는다.
    #    user_groups_controller#update 가 use_limit/limit_message/limit_month_purchase/limit_week_purchase 를
    #    params.except! 로 명시적으로 제거하기 때문 — 한도는 이 전용 라우트로만 바뀐다.
    # 서버 scope: manager:limit
    def user_group_limit(user_group_id:, use_limit: nil, limit_month_purchase: nil,
                         limit_week_purchase: nil, limit_message: nil, idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}/limit",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        },
        payload: {
                   use_limit:            use_limit,
                   limit_month_purchase: limit_month_purchase,
                   limit_week_purchase:  limit_week_purchase,
                   limit_message:        limit_message
                 }.compact
      )
    end

    # 그룹 구독 합산청구(정산주기) 설정을 변경한다 (PUT /v1/user-groups/:id/aggregate-transaction)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # update_user_group 에도 같은 이름의 인자가 있지만 서버는 이 전용 라우트에서만 처리한다.
    def user_group_aggregate_transaction(user_group_id:, use_subscription_aggregate_transaction: nil,
                                         subscription_month_day: nil, subscription_week_day: nil,
                                         idempotency_key: nil)
      request(
        uri:     "user-groups/#{user_group_id}/aggregate-transaction",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        },
        payload: {
                   use_subscription_aggregate_transaction: use_subscription_aggregate_transaction,
                   subscription_month_day:                 subscription_month_day,
                   subscription_week_day:                  subscription_week_day
                 }.compact
      )
    end
  end
end