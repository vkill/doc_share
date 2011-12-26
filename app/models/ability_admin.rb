class AbilityAdmin
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.has_role? :admin
      can :access, :all
    end
    
  end

end