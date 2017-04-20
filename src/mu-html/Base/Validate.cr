
module Mu_Html

  class Validate
    def self.error_message(mod : Class, o : Hash(String, JSON::Type), k : String)
      "Invalid value in #{mod.tag_name}: #{k}: #{o[k]?.inspect}"
    end
  end # === class Validate

  class Required_Key < Validate

    def self.validate(mod : Class, o : Hash(String, JSON::Type), k : String)
      return o if o.has_key?(k)
      raise Exception.new("Missing value in #{mod.tag_name}: #{k}")
    end

  end # === class Required_Key

  class Is_String < Validate

    def self.==(str : String)
      true
    end

    def self.==(o)
      false
    end

  end # === class Is_String

  class Is_Nil < Validate

    def self.==(n : Nil)
      true
    end

    def self.==(o)
      false
    end

  end # === class Is_Nil

  class Is_Non_Empty_String < Validate

    def self.==(str : String)
      !str.strip.empty?
    end

    def self.==(o)
      false
    end

  end # === class Empty_String

  class Is_Empty_String < Validate

    def self.==(str : String)
      str.strip.empty?
    end

    def self.==(o)
      false
    end

  end # === class Empty_String

end # === module Mu_Html

