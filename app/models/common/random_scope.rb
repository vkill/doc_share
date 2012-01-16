module RandomScope
  def self.included(model)
    model.class_eval do
      if connection.adapter_name == "MySQL"
        scope :random, lambda { |amount|
          if(amount)
            {:order => "RAND()", :limit => amount}
          else
            {:order => "RAND()"}
          end
        }
      else
        scope :random, lambda { |amount|
          if(amount)
            {:order => "RANDOM()", :limit => amount}
          else
            {:order => "RANDOM()"}
          end
        }
      end
    end
  end
end