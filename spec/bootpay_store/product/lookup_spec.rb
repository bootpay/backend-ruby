RSpec.describe BootpayStore::RestClient do
  it "lookup product" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
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