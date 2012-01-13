class AbilityAdmin
  include CanCan::Ability

  def initialize(user)

    user ||= User.new


    if user.super_admin?
      can :access, :all
      can :access, Resque
    elsif user.has_role? :admin
      can :access, :all
      cannot :access, Resque
    end
    
  end

end