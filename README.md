# Bootpay Ruby 플러그인 

Bootpay Ruby 라이브러리는 Ruby 언어로 작성된 어플리케이션, 프레임워크 등에서 사용가능합니다.

## Installation

Gemfile 파일을 이용하여 설치하기  

```ruby
gem 'bootpay'
```

Gemfile에 위 라인을 추가하고, 아래 라인으로 인스톨 합니다.

    $ bundle install



또는 아래 문장을 통해 바로 설치할 수 있습니다:

    $ gem install backend-ruby

## Getting Started

```ruby
    # 결제 검증하기 
    receipt_id = '612df0250d681b001de61de6'

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success?
      response = api.verify(receipt_id)
      print  response.data.to_json
    end
```

## Documentation

[부트페이 개발매뉴얼](https://app.gitbook.com/@bootpay)을 참조해주세요

## 기술문의

[부트페이 홈페이지](https://www.bootpay.co.kr) 우측 하단 채팅을 통해 기술문의 주세요!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
