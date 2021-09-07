
## Bootpay Java Server Side Library
부트페이 공식 Ruby 라이브러리 입니다 (서버사이드 용)

Ruby 언어로 작성된 어플리케이션, 프레임워크 등에서 사용가능합니다.

* PG 결제창 연동은 클라이언트 라이브러리에서 수행됩니다. (Javascript, Android, iOS, React Native, Flutter 등)
* 결제 검증 및 취소, 빌링키 발급, 본인인증 등의 수행은 서버사이드에서 진행됩니다. (Java, PHP, Python, Ruby, Node.js, Go, ASP.NET 등)


## 기능   
1. (부트페이 통신을 위한) 토큰 발급 요청   
2. 결제 검증   
3. 결제 취소 (전액 취소 / 부분 취소)
4. 빌링키 발급
   
    4-1. 발급된 빌링키로 결제 승인 요청
   
    4-2. 발급된 빌링키로 결제 승인 예약 요청
   
    4-2-1. 발급된 빌링키로 결제 승인 예약 - 취소 요청
   
    4-3. 빌링키 삭제
5. (부트페이 단독) 사용자 토큰 발급   
6. (부트페이 단독) 결제 링크 생성   
7. 서버 승인 요청   
8. 본인 인증 결과 조회

## Gem으로 설치하기 


```ruby
gem 'bootpay'
```

Gemfile에 위 라인을 추가하고, 아래 라인으로 인스톨 합니다.

    $ bundle install



또는 아래 문장을 통해 바로 설치할 수 있습니다:

    $ gem install backend-ruby

## 사용하기 

```ruby
    # 결제 검증하기 
    receipt_id = '612df0250d681b001de61de6'

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success? 
      print  response.data.to_json
    end
```
함수 단위의 샘플 코드는 [이곳](https://github.com/bootpay/backend-ruby/tree/main/spec/bootpay)을 참조하세요.


## 1. 토큰 발급 

부트페이와 서버간 통신을 하기 위해서는 부트페이 서버로부터 토큰을 발급받아야 합니다.  
발급된 토큰은 30분간 유효하며, 최초 발급일로부터 30분이 지날 경우 토큰 발급 함수를 재호출 해주셔야 합니다.
```ruby 
api = Bootpay::Api.new(
  application_id: '5b8f6a4d396fa665fdc2b5ea',
  private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
)
if api.request_access_token.success? 
  print  response.data.to_json
end
```


## 2. 결제 검증 
결제창 및 정기결제에서 승인/취소된 결제건에 대하여 올바른 결제건인지 서버간 통신으로 결제검증을 합니다.
```ruby  
Bootpay bootpay = new Bootpay("5b8f6a4d396fa665fdc2b5ea", "rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=");

try {
    ResDefault<VerificationData> res = bootpay.verify("6100e8e7019943003850f9b0");
    System.out.println(res.toJson());
} catch (Exception e) {
    e.printStackTrace();
}
```

## Documentation

[부트페이 개발매뉴얼](https://app.gitbook.com/@bootpay)을 참조해주세요

## 기술문의

[부트페이 홈페이지](https://www.bootpay.co.kr) 우측 하단 채팅을 통해 기술문의 주세요!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
