
class DestroyAwsContent
   @queue = :default
  
  def self.perform(key)

    s3 = AWS::S3.new
    aws_bucket = s3.buckets['harshtrivedi']
    documents = aws_bucket.objects.with_prefix(  key  ).delete_all
    ap "In DestroyAwsContent job : #{key}"    
    ap documents

  end
end