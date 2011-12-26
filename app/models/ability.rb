class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user
      can :access, :all
    end

  end

end
