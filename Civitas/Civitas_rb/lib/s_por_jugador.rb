# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SPorJugador < Sorpresa
    def initialize(valor, texto)
      init
      @valor = valor
      @texto = texto
    end
    
    def aplicarAJugador(actual, todos)
      aplicarAJugador_porJugador(actual, todos)
    end
    
    private
    def aplicarAJugador_porJugador(actual, todos)
      puts"_____ARREGLASR___"
        if jugadorCorrecto(actual, todos)
            informe(actual, todos)
            s = Sorpresa.sorpresaDinero(TipoSorpresa::PAGARCOBRAR, @valor*(-1), "Retirada de dinero")
            for i in (0..todos.length-1)
                if i != actual
                    s.aplicarAJugador_pagarCobrar(i, todos)
                end
            end
            s = Sorpresa.sorpresaDinero(TipoSorpresa::PAGARCOBRAR, @valor*(todos.length-1), "-")
            s.aplicarAJugador_pagarCobrar(actual, todos)
        end
    end
    
  end
end
