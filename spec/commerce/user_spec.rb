# frozen_string_literal: true

RSpec.describe "Commerce API - User", :integration do
  let(:commerce) do
    api = create_commerce_api
    api.get_access_token
    api.as_manager
    api
  end

  it "lists users" do
    response = commerce.user.list(page: 1, limit: 10)

    puts "=== Commerce User List Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "creates a user via join" do
    user_data = {
      login_id: "test_user_#{Time.now.to_i}@example.com",
      login_pw: 'test1234!',
      username: '테스트유저',
      email:    "test_user_#{Time.now.to_i}@example.com",
      phone:    '01012341234'
    }

    response = commerce.user.join(user_data)

    puts "=== Commerce User Join Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "checks if a user exists" do
    response = commerce.user.check_exist('email', 'test@example.com')

    puts "=== Commerce User Check Exist Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "issues a user token" do
    response = commerce.user.token('test_user_id')

    puts "=== Commerce User Token Response ==="
    puts response.to_json

    expect(response).not_to be_nil
  end

  it "gets user detail" do
    # 먼저 목록에서 user_id를 가져온 후 상세 조회
    list_response = commerce.user.list(page: 1, limit: 1)

    puts "=== Commerce User List for Detail ==="
    puts list_response.to_json

    if list_response.is_a?(Hash) && list_response[:data].is_a?(Hash) && list_response[:data][:items].is_a?(Array)
      items = list_response[:data][:items]
      if items.length > 0
        user_id = items[0][:user_id]
        response = commerce.user.detail(user_id)

        puts "=== Commerce User Detail Response ==="
        puts response.to_json

        expect(response).not_to be_nil
      end
    end

    expect(list_response).not_to be_nil
  end
end
