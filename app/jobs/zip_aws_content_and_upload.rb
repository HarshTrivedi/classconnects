require 'aws-sdk'
require 'awesome_print'
require 'fileutils'
require 'zip_file_generator.rb'
require 'active_job'
require 'pusher'

#bundle exec rake environment resque:work QUEUE=*
#Do this to start the server

class ZipAwsContentAndUpload 
   @queue = :default
  
  def self.perform(downloader_id , bucket_id)

	bucket = Bucket.find_by_id(bucket_id)
	bucket.zip_url  	
	bucket.last_zip_time = DateTime.now
	bucket.download_waiter_ids

	original_zip_url = bucket.zip_url
	original_last_zip_time = bucket.last_zip_time
	original_download_waiter_ids = bucket.download_waiter_ids
	original_updated_at = bucket.updated_at

  	if not bucket.zip_being_formed 
  		begin
			bucket.zip_being_formed = true
			bucket.save
			###################################

		    user = User.find_by_id(downloader_id)

		    aws_prefix = bucket.aws_root_to_self_path
		    s3 = AWS::S3.new
			aws_bucket = s3.buckets[ ENV['S3_BUCKET'] ]
			documents = aws_bucket.objects.with_prefix( aws_prefix ).collect(&:key)

			ap "Listing documents starts"
			ap documents	
			ap "Listing documents ends"
			
			local_storage_path = File.join( Rails.root , '..' , "background_storage" , Rails.env ).to_s

			#clean before creating (Cleaning required in case previous one was rescued  and toggle is changed in resuce block ; and code block )
			FileUtils.rm_rf(    File.dirname(File.join( local_storage_path , aws_prefix)) )		
			FileUtils.mkdir_p( File.join( local_storage_path , aws_prefix )   )

			ap "Now will start to download files in local folder"
			for document in documents
				ap "About to write Document :: #{document}"
				directory_path = File.join( local_storage_path ,  File.dirname( document )  )
				document_path = File.join( local_storage_path ,  document )
				
				FileUtils.mkdir_p( directory_path ) if not File.directory?(directory_path)
				File.open( document_path , 'wb') do |f|
					f.write(aws_bucket.objects[document].read)
				end
				ap "Document  :#{document}: written"
			end	
			ap "All files downloaded"

			ap "About to start to make the zip"
			directoryToZip = File.join( local_storage_path , aws_prefix ) 
			outputFile = File.join( local_storage_path , "#{aws_prefix}.zip" )
			zf = ZipFileGenerator.new(directoryToZip, outputFile)
			zf.write()
			ap "Zip generated : directoryToZip: #{directoryToZip}     || outputFile : #{outputFile}"

			key = "zip/#{aws_prefix}.zip"
			ap "Now will upload zip to aws at key   #{key}"
			puts "Uploading file #{outputFile} to bucket harshtrivedi."
			aws_bucket.objects[key].write(:file => outputFile)	
			
			url = aws_bucket.objects[key].public_url.to_s

			ap "URL got is ::::  #{url}"

			ap "About to clean the local folder :  #{  File.dirname(File.join( local_storage_path , aws_prefix))  }"
			FileUtils.rm_rf(    File.dirname(File.join( local_storage_path , aws_prefix)) )

			###################################
			ap "------------bucket-----------------"
			ap bucket

			bucket.zip_url = url
			ap bucket

			bucket.last_zip_time = DateTime.now
			ap bucket

			waiter_ids = bucket.download_waiter_ids.uniq
			ap "My waiters are   #{waiter_ids}"
			for waiter_id in waiter_ids
				ap "My waiter #{waiter_id}"
				user = User.find_by_id(waiter_id)
				ap user
		        user.update_attributes(:ready_bucket_ids => ( user.ready_bucket_ids + [bucket.id] ) )
		        
				ap user

		        # pending_request_bucket_ids = user.pending_request_bucket_ids
		        # ap "pending_request_bucket_ids : #{pending_request_bucket_ids}"
		        # pending_request_bucket_ids.delete("#{bucket.id}")
		        # ap "pending_request_bucket_ids : #{pending_request_bucket_ids}   --- after deletion of #{bucket.id}"
		        # user.update_attributes(:pending_request_bucket_ids => pending_request_bucket_ids.dup )
		        user.pending_request_bucket_ids.delete("#{bucket.id}")
		        user.pending_request_bucket_ids_will_change!
		        user.save
		        ap user
		        ap user.reload
		        Pusher['private-' + waiter_id.to_s ].trigger('ready_download', { :message => "update download notifications" })
			end

			bucket.download_waiter_ids = []
			bucket.zip_being_formed = false
			bucket.updated_at = original_updated_at
			ap bucket

			ap "------------bucket before saveing-----------------"
			ap bucket.class
			bucket.save
			ap bucket

		rescue
			ap "Fallen In to an ERROR"
			ap "About to restore the bucket"
			bucket.reload
			bucket.zip_url = original_zip_url 
			bucket.last_zip_time = original_last_zip_time 
			bucket.download_waiter_ids = original_download_waiter_ids
			bucket.zip_being_formed = false
			bucket.save
			bucket.reload
		end	
	end

  end
end