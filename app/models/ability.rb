class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :access, :all
    else
      can :access, :home
      can :create, [:users, :sessions]
    end

  end
end
