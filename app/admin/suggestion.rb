ActiveAdmin.register Suggestion do
  menu :label => "Suggestion" , :priority => 8

  config.clear_action_items!      

  index do
      column :user_id do |suggestion|
          user = User.find_by_id(suggestion.user_id)
          user.full_name rescue ""
      end
      column :college_name do |suggestion|
          suggestion.college_name
      end 
      column :branch_name do |suggestion|
          suggestion.branch_name
      end 
      column :course_name do |suggestion|
          suggestion.course_name
      end 

      column :message do |suggestion|
          suggestion.message
      end
      column :created_at do |suggestion|
          "#{time_ago_in_words( suggestion.created_at )} ago"
      end
      column :view do |suggestion|
          link_to("view" , admin_suggestion_path(suggestion) )
      end
      column :destroy do |suggestion|
          link_to("destroy" , admin_suggestion_path(suggestion) , :method => :delete , data: { confirm: "Are you sure u want to delete this Suggestion ?" } ) if can?(:destroy , suggestion )
      end
  end
   
  action_item :only => [:show] do
    # Destroy link on show
    if can?(:destroy, resource) && controller.action_methods.include?("destroy")
      link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name), resource_path(resource),
        :method => :delete  , data: { confirm: "Are you sure u want to delete this Resource ?" }   )
    end
  end


  filter :college_name , :label => "college name"
  filter :branch_name , :label => "branch name"
  filter :course_name , :label => "course name"

end
