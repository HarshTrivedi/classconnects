ActiveAdmin.register NewsLetter do
  menu :label => "NewsLetter" , :priority => 10


  index do
      column :user_name do |news_letter|
      		news_letter.user_name
      end
      column :email do |news_letter|
          	news_letter.email
      end
      column :message do |news_letter|
	      news_letter.message
      end
      column :created_at do |news_letter|
          "#{time_ago_in_words( news_letter.created_at )} ago"
      end
      column :destroy do |news_letter|
          link_to("destroy" , admin_news_letter_path(news_letter) , :method => :delete , data: { confirm: "Are you sure u want to delete this news letter entry ?" } ) if can?(:destroy , news_letter )
      end
  end


  config.clear_action_items!   

  filter :user_name , :label => "User Name"
  filter :email , :label => "Email"
  filter :message , :label => "message"      
end
