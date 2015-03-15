S3DirectUpload.config do |c|
  c.access_key_id = "AKIAIZPYBJBUBN7HBUWA"                # your access key id
  c.secret_access_key = "7HKgDXUsNlG1HPqwK/HdwwynEFBKjJfykHbZ9vpW"   # your secret access key
  c.bucket = "classcollabdevelopment"                             # your bucket name
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
