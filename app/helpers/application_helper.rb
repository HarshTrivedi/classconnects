module ApplicationHelper


	def awesome_print_html(object)
		(ap object , {:html => true , :color => { :array  => :black } } ).gsub(/style="/ , 'style="background-color:transparent;').html_safe
	end


	def avatar_url(user)
		# if user.avatar_url.present?
		#     user.avatar_url
		# else
	    # default_url = "#{root_url}images/guest.png"
	    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
	    # "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
		# end
		"http://gravatar.com/avatar/#{gravatar_id}.png?d=identicon"
	end


	def bootstrap_class_for flash_type
	    case flash_type
	      when :success
	        "alert-success"
	      when :error
	        "alert-error"
	      when :alert
	        "alert-block"
	      when :notice
	        "alert-info"
	      else
	        flash_type.to_s
	    end
	end

end
