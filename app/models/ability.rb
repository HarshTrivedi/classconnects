class Ability
  include CanCan::Ability
 
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.role? :super_admin
        can :manage, :all
    elsif user.role? :college_generator
        can :manage, College
        can :manage, CollegeBranchPair
        can :manage, Branch
        can :manage, Course
        can :read, :all

    elsif user.role? :content_generator
        can :create, Bucket
        can :update, Bucket
        can :create, Folder
        can :update, Folder
        can :create, Document
        can :update, Document
        can :manage, Category
        can :destroy, Suggestion
        # can :manage, InappropriateReport
        can :read, :all

    elsif user.role? :content_moderator
        can :destroy, ReportedInappropriate
        can :manage, InappropriateType
        can :destroy, Bucket
        can :update,  Bucket
        can :destroy, Folder
        can :update,  Folder
        can :destroy, Document
        can :update,  Document
        can :destroy, Comment
        can :destroy, CommentResponse
        can :read, :all
    else

    end
  end
end