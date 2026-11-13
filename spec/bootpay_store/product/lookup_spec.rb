RSpec.describe BootpayStore::RestClient do
  it "lookup product" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.lookup_product(
        product_id: '66fa14954eac568eab4fc2d0'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end