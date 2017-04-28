
require "./A"
require "./Tag"

# === Include the tags: =======
require "./P"
require "./DIV"
require "./EACH"
require "./FOOTER"
require "./INPUT"
require "./SPAN"
# =============================

module Mu_Html

  module Markup

    REGEX = {
      id:      /^[a-z0-9\_]+$/,
      class:   /^[a-z0-9\-\_\ ]+$/,
      data_id: /^[a-z0-9\_\.\-]+$/
    }

    def self.clean(data : Hash(String, JSON::Type))
      return nil unless data.has_key?("markup")
      State.new(data)
      nil
    end

    struct State

      getter origin   : Hash(String, JSON::Type)

      def initialize(@origin)
        raw         = @origin["markup"]?
        self_markup = self

        case raw

        when Array(JSON::Type)
          raw.each { | raw_tag |
            case raw_tag
            when Hash(String, JSON::Type)
              Tag.clean(self_markup, raw_tag)
            else
              raise Exception.new("Invalid value: #{raw_tag}")
            end
          }

        when Nil
          raise Exception.new("Invalid markup.")

        else
          raise Exception.new("Markup can only be an Array of tags.")

        end # === case
      end # === def initialize

      def markup
        @origin["markup"]
      end

    end # === struct State

  end # === module Markup
end # === module Mu_Html
