class Search

  include BasicModel

  attr_accessor :type, :q

  def self.get_type_values
    [
      [I18n.translate(:"activemodel.enums.search.type.users"), "users"],
      [I18n.translate(:"activemodel.enums.search.type.repositories"), "repositories"],
      [I18n.translate(:"activemodel.enums.search.type.everything"), "everything"]
    ]
  end

  validate :build_type

  private

    def build_type
      self.type = "everything" if self.type.blank?
    end

end