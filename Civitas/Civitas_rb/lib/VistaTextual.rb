# encoding: utf-8

require_relative 'Diario.rb'
require_relative 'Operaciones_juego.rb'
require_relative 'Respuestas.rb'
require 'io/console'

module Civitas
  class VistaTextual

    @@separador = "====================="
    def initialize
      @iGestion = -1
      @iPropiedad = -1
      @juegoModel = nil
    end
    
    public
    def mostrar_estado(estado)
      puts estado
    end

    def pausa
      print "Pulsa una tecla"
      STDIN.getch
      print "\n"
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end



    def menu(titulo, lista)
      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n"+tab+"Elige una opción: ",
                          tab+"Valor erróneo")
      return opcion
    end

    
    def comprar
      opcion = menu("¿Desea comprar la calle?", ["NO","SI"])
      return Respuestas::Lista_respuestas[opcion]
    end

    def gestionar
      @iGestion = menu("Que gestión inmobiliaria desea", ["Vender","Hipotecar","Cancelar hipoteca","Construir casa","Construir hotel","Terminar"])
      
      propiedades = @juegoModel.getJugadorActual().getPropiedades()
      props = []
      if @iGestion != 5
        for p in propiedades
          props << p.nombre
        end
        @iPropiedad = menu("¿Sobre que propiedad quiere realizar una gestión?", props)
      end
      
    end

    def getGestion
      @iGestion
    end

    def getPropiedad
      @iPropiedad
    end

    def mostrarSiguienteOperacion(operacion)
      puts "Siguiente operación: " + operacion.to_s
    end

    def mostrarEventos
        while( Diario.instance.eventos_pendientes ) 
            puts Diario.instance.leer_evento
        end
    end

    def setCivitasJuego(civitas)
        @juegoModel = civitas
        actualizarVista
    end

    def actualizarVista
      puts "#{@juegoModel.getJugadorActual().to_s}"
      jugador = @juegoModel.getJugadorActual()
      propiedades = jugador.getPropiedades()
      for t in propiedades
        puts t
      end
      print "\n"
    end
  end
end
