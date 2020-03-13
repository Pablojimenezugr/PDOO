require_relative 'jugador_especulador.rb'

module Civitas
  class SJugadorEspeculador < Sorpresa
    
    def initialize(valor, texto)
      @valor = valor
      @texto = texto
    end
    
    def aplicarAJugador(actual, todos)
      aplicarAJugador_transformacion(actual, todos)
    end
    
    private 
    def aplicarAJugador_transformacion(actual, todos)
      
      if jugadorCorrecto(actual , todos)
        informe(actual, todos)
        candidato = todos[actual]
        todos[actual] = JugadorEspeculador.new(candidato, @valor)
      
        puts "_____Acabo de crear unnuevo especulador_____SJugadorEspeculador"
        
      end
      
    end
    
    
  end
end
