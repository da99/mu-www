
module Mu_Html

  def_markup do

    attr? "id"
    attr? "class"

    tail!

    render(:tag, :attrs) do
      render(:tail)
    end

  end # === def_markup

end # === module Mu_Html