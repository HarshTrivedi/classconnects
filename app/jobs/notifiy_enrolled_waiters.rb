
class NotifyEnrolledWaiters
  @queue = :default
  
  def self.perform(  user_id , bucket_id )

  	user = User.find_by_id(user_id)
    bucket = Bucket.find_by_id(bucket_id)
  	course = bucket.course

  	users = course.enrolled_users

  	users = users.to_a - user

  	for user in users
      notification = Notification.new 
      notification.user_id = user.id 
      notification.message = "A new bucket : #{bucket.name} : added in #{course.name}" 
      notification.link = "buckets/#{bucket.id}/content"
      notification.save
	  end

  end
end