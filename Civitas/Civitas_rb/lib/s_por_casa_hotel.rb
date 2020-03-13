# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class SPorCasaHotel < Sorpresa
    def initialize(valor, texto)
      init
      @valor = valor
      @texto = texto
    end
    
    def aplicarAJugador(actual, todos)
      aplicarAJugador_porCasaHotel(actual, todos)
    end
    
    private
    def aplicarAJugador_porCasaHotel(actual, todos)
        if jugadorCorrecto(actual, todos)
            informe(actual, todos)
            numCasasHoteles = todos[actual].cantidadCasasHoteles
            todos[actual].modificarSaldo(valor * numCasasHoteles)
        end
    end
  end
end
