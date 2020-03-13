# encoding: utf-8

require_relative 'Tablero.rb'
require_relative 'Diario.rb'
require_relative 'Dado.rb'
require_relative 'Jugador.rb'
require_relative 'MazoSorpresa.rb'
require_relative 'TituloPropiedad.rb'
require_relative 'Operaciones_juego.rb'
require_relative 'gestor_estados.rb'
require_relative 'c_calle.rb'
require_relative 'c_sorpresa.rb'
require_relative 'c_juez.rb'
require_relative 'c_impuesto.rb'
require_relative 's_jugador_especulador.rb'
require_relative 's_pagar_cobrar.rb'
require_relative 's_por_jugador.rb'
require_relative 's_salir_carcel.rb'
require_relative 's_ir_carcel.rb'
require_relative 's_ir_casilla.rb'
require_relative 's_por_casa_hotel.rb'

module Civitas
    class CivitasJuego
      
        def initialize(nombres)
            @jugadores = []
            for i in nombres
                @jugadores << Jugador.new(i)
            end

            @gestorEstado = GestorEstados.new
            @estado = @gestorEstado.estado_inicial()

            @indiceJugadorActual = Dado.instance.quienEmpieza(@jugadores.length)
          
            @mazo = MazoSorpresas.new
            inicializarTablero(@mazo)
            inicializarMazoSorpresas(@tablero)          
        end

        private
        def avanzaJugador
            jugadorActual = @jugadores[@indiceJugadorActual]
            posActual = jugadorActual.numCasillaActual
            tirada = Dado.instance.tirar
            posicionNueva = @tablero.nuevaPosicion(posActual, tirada)
            casilla = @tablero.getCasilla(posicionNueva)
            contabilizarPasosPorSalida(jugadorActual)
            jugadorActual.moverACasilla(posicionNueva)
            casilla.recibeJugador(posActual, @jugadores)
            contabilizarPasosPorSalida(jugadorActual)
        end

        def contabilizarPasosPorSalida(jugadorActual)
            while @tablero.getPorSalida() > 0
                jugadorActual.pasaPorSalida()
            end
        end

        def inicializarMazoSorpresas(tablero) # hay una sorpresa que necesita un tablero
            @mazo.alMazo(SJugadorEspeculador.new(200, "Transformar al jugador en un especulador"))
            @mazo.alMazo(SPagarCobrar.new(400, "Sumas 400€"))
            @mazo.alMazo(SPagarCobrar.new(-400, "Restas 400€"))
            @mazo.alMazo(SPorJugador.new(200, "Recibe 200€ por jugador"))
            @mazo.alMazo(SPorJugador.new(-200, "Da 200€ por jugador"))
            @mazo.alMazo(SSalirCarcel.new(@mazo))
            @mazo.alMazo(SIrCarcel.new(tablero))
            @mazo.alMazo(SPorCasaHotel.new(300, "Cobra 300€ por cada casa/hotel"))
            @mazo.alMazo(SPorCasaHotel.new(-300, "Paga 300€ por cada casa/hotel"))
            @mazo.alMazo(SPorCasaHotel.new(8, "Ve a la casilla 8"))
            @mazo.alMazo(SIrCasilla.new(tablero, 18, "Ve a la casilla 18"))
        end

        def inicializarTablero(mazo) 
            @tablero = Tablero.new(9) # carcel
            @tablero.aniadeCasilla(Casilla.new("SALIDA"))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 1", 200, 1.2, 250, 200, 500)))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 2", 200, 1.2, 250, 200, 500)))
            @tablero.aniadeCasilla(CSorpresa.new(mazo, "Sorpresa 1"))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 3", 400, 1.3, 350, 300, 700)))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 4", 200, 1.2, 250, 200, 500)))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 5", 400, 1.3, 350, 300, 700)))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 6", 200, 1.2, 250, 200, 500)))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 7", 200, 1.2, 250, 200, 500)))
            @tablero.aniadeCasilla(Casilla.new("CÁRCEL"))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 8", 400, 1.3, 350, 300, 700)))
            @tablero.aniadeCasilla(CSorpresa.new(mazo, "Sorpresa 2"))
            @tablero.aniadeCasilla(CJuez.new(9, "JUEZ"))
            @tablero.aniadeJuez()
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 9", 400, 1.3, 350, 300, 700)))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 10", 400, 1.3, 350, 300, 700)))
            @tablero.aniadeCasilla(CSorpresa.new(mazo, "Sorpresa 3"))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 11", 400, 1.3, 350, 300, 700)))
            @tablero.aniadeCasilla(Casilla.new("PARKING"))
            @tablero.aniadeCasilla(CCalle.new(TituloPropiedad.new("CALLE 12", 400, 1.3, 350, 300, 700)))
            @tablero.aniadeCasilla(CImpuesto.new(380.08, "IMPUESTO"))
        end

        def pasarTurno
            @indiceJugadorActual = ( @indiceJugadorActual + 1 ) % @jugadores.length
        end

        def ranking
          salida = @jugadores
          salida.sort { |a, b| b <=> a }
          salida
        end

        public
        def cancelarHipoteca(ip)
            @jugadores[ip].cancelarHipoteca(ip)
        end

        def comprar
            jugadorActual = @jugadores[@indiceJugadorActual]
            puts "#{jugadorActual.nombre}"
            numCasillaActual = jugadorActual.numCasillaActual
            puts "numero de la casilla actual #{numCasillaActual}"
            casilla = @tablero.getCasilla(numCasillaActual)
            puts "casilla #{casilla.nombre}"
            titulo = casilla.getTituloPropiedad
            if titulo == nil
              puts "JUEGO::COMPRAR titulo null"
            end
            res = jugadorActual.comprar(titulo)
            res
        end

        def construirCasa(ip)
            @jugadores[@indiceJugadorActual].construirCasa(ip)
        end

        def construirHotel(ip)
            @jugadores[@indiceJugadorActual].construirHotel(ip)
        end

        def construirCasa(ip)
            @jugadores[ip].construirCasa(ip)
        end

        def getCasillaActual()
            @tablero.getCasilla(@indiceJugadorActual)
        end

        def getJugadorActual()
            @jugadores[@indiceJugadorActual]
        end

        def hipotecar ip
            @jugadores[ip].hipotecar(ip)
        end

        def infoJugadorTexto()
            i = @indiceJugadorActual
            "El jugador #{@jugadores[i].nombre}  tiene #{@jugadores[i].saldo}."
        end

        def finalDelJuego
            salida = false
            for i in @jugadores
                if i.enBancarrota()
                    salida = true
                end
            end
            salida
        end

        def salirCarcelPagando
            @jugadores[@indiceJugadorActual].salirCarcelPagando
        end

        def salirCarcelTirando
            @jugadores[@indiceJugadorActual].salirCarcelTirando
        end

        def siguientePaso
            jugadorActual = @jugadores[@indiceJugadorActual]
            operacion = @gestorEstado.operaciones_permitidas(jugadorActual, @estado)
            if operacion == Operaciones_juego::PASAR_TURNO
                pasarTurno()
                siguientePasoCompletado(operacion)
            elsif operacion == Operaciones_juego::AVANZAR
                avanzaJugador()
                siguientePasoCompletado(operacion)
            end
            return operacion
        end

        def siguientePasoCompletado(operacion)
            @estado = @gestorEstado.siguiente_estado(@jugadores[@indiceJugadorActual], @estado, operacion);
        end 

        def vender(ip)
            @jugadores[@indiceJugadorActual].vender(ip)
        end
    end
end