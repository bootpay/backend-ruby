# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "verification" do
    print "\nverification\n"
    receipt_id = '612df0250d681b001de61de6'

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success?
      response = api.verify(receipt_id)
      print  response.data.to_json
    end
  end

  # it 'subscribe_verify' do
  #   print "\nsubscribe_verify subscribe_verify\n"
  #   billing_key = '612e04840d681b001de61ebb'
  #
  #   api = Bootpay::Api.new(
  #     application_id: '5b8f6a4d396fa665fdc2b5ea',
  #     private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
  #     )
  #   if api.request_access_token.success?
  #     response = api.subscribe_verify(billing_key)
  #     print  response.data.to_json
  #   end
  # end
end
