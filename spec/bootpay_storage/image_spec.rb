# frozen_string_literal: true

RSpec.describe BootpayStorage::RestClient do
  let(:image_path) { File.expand_path('../fixtures/logo.png', __dir__) }

  it "image" do
    commerce_api = BootpayStore::RestClient.new(
      server_key:     '67c92fb8d01640bb9859c612',
      private_key:    ENV['BOOTPAY_PRIVATE_KEY'],
      mode:           'development'
    )
    res = commerce_api.request_access_token

    api         = BootpayStorage::RestClient.new(
      server_key:     '67c92fb8d01640bb9859c612',
      private_key:    ENV['BOOTPAY_PRIVATE_KEY'],
      mode:           'development'
    )
    api.set_token(res.data[:access_token])
    file = File.open(image_path)

    response = api.image_upload(images: [file])
    file.close

    print response.data.to_json
  end
end
