class AbilityAccount
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new

    if user.persisted?
      can :access, :all
    end
  
  end

end