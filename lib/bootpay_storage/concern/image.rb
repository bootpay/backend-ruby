module BootpayStorage::Concern::Image
  extend ActiveSupport::Concern

  included do


    # REST API로 본인인증 요청하기
    # Comment by Gosomi
    # Date: 2022-11-02
    def image_upload(images:)
      upload(
        uri:     'images',
        images: images
      )
    end

    # 업로드한 이미지를 URL 로 삭제한다.
    # 업로드 응답이 URL 만 돌려주므로(내부 식별자 미노출) 삭제도 URL 을 키로 받는다.
    # Comment by Claude (alfred)
    # @date: 2026-07-28
    def image_destroy(url:)
      request(
        method:  :delete,
        uri:     'images/by_url',
        payload: { url: url }
      )
    end

  end
end