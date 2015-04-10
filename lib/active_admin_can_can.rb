# module ActiveAdminCanCan
# end

# 	def can?(action, resource)
# 	  controller.current_ability.can?(action, resource)
# 	end
	 
# 	def active_admin_allowed_action_items
	 
# 	  config.clear_action_items!	 
# 	  action_item :except => [:new, :show] do
# 	    # New link
# 	    if can?(:create, active_admin_config.resource_class) && controller.action_methods.include?('new')
# 	      link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
# 	    end
# 	  end
	 
# 	  action_item :only => [:show] do
# 	    # Edit link on show
# 	    if can?(:update, resource) && controller.action_methods.include?('edit')
# 	      link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
# 	    end
# 	  end
	 
# 	  action_item :only => [:show] do
# 	    # Destroy link on show
# 	    if can?(:destroy, resource) && controller.action_methods.include?("destroy")
# 	      link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name), resource_path(resource),
# 	        :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'))
# 	    end
# 	  end
# 	end
	 
# 	# Adds links to View, Edit and Delete
# 	# This override will only display the links that are allowed for the user
# 	def actions(options = {})
# 	  options = {
# 	    :name => ""
# 	  }.merge(options)
# 	  column options[:name] do |resource|
# 	    links = ''.html_safe
# 	    if can?(:read, resource) && controller.action_methods.include?('show')
# 	      links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
# 	    end
# 	    if can?(:update, resource) && controller.action_methods.include?('edit')
# 	      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
# 	    end
# 	    if can?(:destroy, resource) && controller.action_methods.include?('destroy')
# 	      links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
# 	    end
# 	    links
# 	  end
# 	end  

