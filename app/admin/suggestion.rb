ActiveAdmin.register Suggestion do
  menu :label => "Suggestion" , :priority => 8

  config.clear_action_items!   
  action_item :except => [:new, :show , :index ] do
    if can?(:create, active_admin_config.resource_class) && controller.action_methods.include?('new')
      link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
    end
  end
   
  action_item :only => [:show] do
    if can?(:update, resource) && controller.action_methods.include?('edit')
      link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
    end
  end
   
  action_item :only => [:show] do
    # Destroy link on show
    if can?(:destroy, resource) && controller.action_methods.include?("destroy")
      link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name), resource_path(resource),
        :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'))
    end
  end


  filter :college_name , :label => "college name"
  filter :branch_name , :label => "branch name"
  filter :course_name , :label => "course name"

end
