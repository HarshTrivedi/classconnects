
class NotifyCoursePeers
   @queue = :default
  
  def self.perform(  user_id , course_id )

  	user = User.find_by_id(user_id)
  	course = Course.find_by_id(course_id)

  	users = course.enrolled_users

  	users = users.to_a - [user]

  	for user in users
      notification = Notification.new 
      notification.user_id = user.id 
      notification.message = "A new user #{user.full_name} has enrolled in #{course.name}"
      notification.link = "/profile_main?user_id=#{user.id}"
      notification.save
  	end

  end
end