ActiveAdmin.register Category do
  menu label: "Category" , :priority => 4
  permit_params :category
  config.filters = false


  controller do
    
    def new
      @category = Category.new
      authorize_me_to(:create , @category)
    end

    def create
      @category = Category.new( permitted_params[:category] )
      authorize_me_to(:create , @category)
      create!
    end 

    def edit
      @category = Category.find_by_id(params[:id])
      authorize_me_to(:update , @category)
    end

    def update
      @category = Category.find(params[:id])
      authorize_me_to(:update , @category)
      update!
    end 

    def destroy
      @category = Category.find(params[:id])
      authorize_me_to(:destroy , @category)
      destroy!
    end

  end 



  index do 
      selectable_column
      column :name do |category|
          link_to( category.to_s , admin_category_path(category) )
      end
      column :created_at
      actions
  end


end
