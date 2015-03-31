S3DirectUpload.config do |c|
  c.access_key_id = ENV["S3_SECRET_KEY"]
  c.secret_access_key = ENV["S3_ACCESS_KEY"]
  c.bucket = ENV["S3_BUCKET"]
end

## URL MonkeyPatch
module S3DirectUpload
  module UploadHelper
    class S3Uploader
      def url
        "http#{@options[:ssl] ? 's' : ''}://#{@options[:bucket]}.#{@options[:region]}.amazonaws.com/"
      end
    end
  end
end
