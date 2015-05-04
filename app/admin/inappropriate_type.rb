ActiveAdmin.register InappropriateType do
  menu label: "Report Types" , :priority => 10
  permit_params :report_type

  filter :report_type , :label => "type"


  index do
      column :report_type do |inappropriate_type|
      		inappropriate_type.report_type
      end
      column :created_at do |inappropriate_type|
          "#{time_ago_in_words( inappropriate_type.created_at )} ago"
      end
      column :edit do |inappropriate_type|
          link_to("edit" , edit_admin_inappropriate_type_path( inappropriate_type )  ) if can?(:update , inappropriate_type )
      end

  end

  config.clear_action_items!   
  action_item :except => [:new, :show ] do
    if can?(:create, active_admin_config.resource_class) && controller.action_methods.include?('new')
      link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
    end
  end

  action_item :only => [:show] do
    if can?(:update, resource) && controller.action_methods.include?('edit')
      link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
    end
  end

end