
module Mu_HTML

  def_markup do
    attr? "id"
    attr? "class"

    render(:tag, :attrs) do
      render(:tail)
    end
  end # === def_markup

end # === module Mu_HTML
