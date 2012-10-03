class Ability

  include CanCan::Ability
  
  def initialize(user)
    if user
      if user.role == "customer"
        can :access, :items, :user_id => user.id
      elsif user.role == "tagger"
        can :access, :items, :taggable => true
      elsif user.role == "admin"
        can :access, :all
      end
    else
      cannot :index, :all
    end
  end


end
