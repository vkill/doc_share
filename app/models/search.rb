class Search

  include BasicModel

  attr_accessor :type, :q

  def self.get_type_values
    [["users", "users"], ["repositories", "repositories"], ["everything", "everything"]]
  end

  validate :build_type

  private

    def build_type
      self.type = "everything" if self.type.blank?
    end

end