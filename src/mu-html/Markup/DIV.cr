
module Mu_Html

  class Markup

    module DIV

      include Tag::Macro

      def_tag do

        required "div" do
          move_to "body" if is?(Is_Non_Empty_String)
          delete if is_either?(nil, Is_Empty_String)
          should_be !exists?
        end

        attr "class" do
          should_be(REGEX["class"])
        end

        attr "body" do
          should_be is_either?(REGEX["data_id"], Array)
          to_markup
        end

      end # === def_tag

    end # === module DIV

  end # === class Markup

end # === module Mu_Html

