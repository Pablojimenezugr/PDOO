
require_relative 'VistaTextual.rb'
require_relative 'CivitasJuego.rb'
require_relative 'Operaciones_juego.rb'
require_relative 'OperacionInmobiliaria.rb'
require_relative 'GestionesInmobiliaria.rb'
require_relative 'Respuestas.rb'
require_relative 'salidas_carcel.rb'

include Civitas::Respuestas
include Civitas::SalidasCarcel
include Civitas::GestionesInmobiliaria

module Civitas

    class Controlador
        def initialize(juego, vista)
            @juego = juego
            @vista = vista
        end

    def juega
      @vista.setCivitasJuego(@juego)
      while(!@juego.finalDelJuego()) 
            @vista.actualizarVista()
            @vista.pausa()
            ope = @juego.siguientePaso()
            @vista.mostrarSiguienteOperacion(ope)
            if(ope != Operaciones_juego::PASAR_TURNO) 
                @vista.mostrarEventos()
                if(!@juego.finalDelJuego()) 
                 
                    case ope 
                    when Operaciones_juego::COMPRAR
                            r = @vista.comprar()
                            if(r == Lista_respuestas[1])
                                @juego.comprar()
                            end
                            @juego.siguientePasoCompletado(ope)
                           
                    when Operaciones_juego::GESTIONAR
                            @vista.gestionar()
                            gestion = @vista.getGestion()
                            propiedad = @vista.getPropiedad()
                            ope_inmo = OperacionInmobiliaria.new(Lista_gestionesInmobiliaria[gestion], propiedad)
                            case ope_inmo.gestion
                            when GestionesInmobiliaria::VENDER
                                @juego.vender(propiedad)
                                    
                                    
                            when GestionesInmobiliaria::HIPOTECAR
                                @juego.hipotecar(propiedad)


                            when GestionesInmobiliaria::CANCELAR_HIPOTECA
                                @juego.cancelarHipoteca(propiedad)


                            when GestionesInmobiliaria::CONSTRUIR_CASA
                                @juego.construirCasa(propiedad)


                            when GestionesInmobiliaria::CONSTRUIR_HOTEL
                                @juego.construirHotel(propiedad)


                            when GestionesInmobiliaria::TERMINAR
                                @juego.siguientePasoCompletado(ope)
                            end
                            
                    when Operaciones_juego::SALIR_CARCEL
                            
                            s = @vista.salirCarcel()
                            
                            if s == salidas_carcel[0]
                                @juego.getJugadorActual().salirCarcelPagando()
                            else
                                @juego.getJugadorActual().salirCarcelTirando()
                            end
                            
                            @juego.siguientePasoCompletado(ope)
                            end
                else 
                    jugadores = @juego.ranking
                    puts "Ganadores del juego: "
                    
                    for j in jugadores
                      puts "#{j.nombre}"
                    end
                end
            end
      end
    end
    end
end