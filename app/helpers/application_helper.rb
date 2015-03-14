module ApplicationHelper


	def awesome_print_html(object)
		(ap object , {:html => true , :color => { :array  => :black } } ).gsub(/style="/ , 'style="background-color:transparent;').html_safe
	end

end
