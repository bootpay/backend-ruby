# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order cancel bill" do
    api   = BootpayStore::RestClient.new(
      server_key:  '644642d87ae4e600391a7cd3',
      private_key: 'tnNiygbEITl62dmDr9zf3uJFMFtT+R3AuB2eEnDqR4M=',
      mode:        'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.request_order_cancel(
        order_number:                    '25051972298187324135',
        cancel_order_subscription_bills: [
                                           {
                                             order_subscription_bill_id: '682ab449978ad361d56817c0',
                                             cancel_quantity:            1
                                           }
                                         ],
        cancel_immediately:              false
      )
      response = api.request_order_cancel(
        order_number:                    '25051972298187324135',
        cancel_order_subscription_bills: [
                                           {
                                             order_subscription_bill_id: '682ab44f978ad361d56817c8',
                                             cancel_quantity:            1
                                           }
                                         ],
        cancel_immediately:              false
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
