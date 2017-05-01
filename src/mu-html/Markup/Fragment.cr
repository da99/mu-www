

module Mu_Html
  module Markup

    struct Fragment

      IGNORED_TAGS = {"page-title", "meta"}
      getter io
      getter parent

      def initialize(@io : IO::Memory, @parent : Page)
        @tags     = Markup.to_array(parent.origin)
        this_fragment = self
        @tags.each { |t|
          case t
          when Hash(String, JSON::Type)
            next if IGNORED_TAGS.includes?(t["tag"]?)
            Node.new(@io, t, this_fragment)
          else
            raise Exception.new("Invalid tag: #{t.inspect}")
          end
        }
      end # === def initialize

      def to_s
        @io.to_s
      end

    end # === struct Fragment
  end # === module Markup
end # === module Mu_Html
