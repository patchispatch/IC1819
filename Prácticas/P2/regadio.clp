; -----------------------------------------------------------------------------
; INGENIERÍA DEL CONOCIMIENTO
; PRÁCTICA 2: SISTEMA INTELIGENTE DE REGADÍO
; AUTOR: JUAN OCAÑA VALENZUELA
; 
; regadio.clp
; Hechos y reglas necesarias para representar un sistema de riego 
; autónomo, con sensores de humedad, temperatura y luminosidad.
; -----------------------------------------------------------------------------

(deffacts plantas
    ; -------------------------------------------
    ; Datos del ambiente al inicio.
    (t_global 80)
    (l_global 600)
    (secado 0)

    ; -------------------------------------------
    ; Datos de alarma de humedad y temperatura para cualquier planta.
    (t_max 40)
    (t_min 5)
    (h_max 200)
    (h_min 850)

    ; -------------------------------------------
    ; Datos de los climas.
    ; Despejado:
    (h despejado 5)
    (t despejado 23)
    (l despejado 1000)

    ; Nublado:
    (h nublado -5)
    (t nublado 18)
    (l nublado 800)

    ; Árido:
    (h arido 20)
    (t arido 35)
    (l arido 2000)

    ; Lluvioso:
    (h lluvioso -20)
    (t lluvioso 15)
    (l lluvioso 500)

    ; -------------------------------------------
    ; Datos de las plantas.
    ; Planta 1: cactus
    (planta cactus 800 300)
    (humedad cactus 400)
    (temperatura cactus 25)
    (luminosidad cactus 500)

    ; Planta 2: tomatera
    (planta tomatera 500 250)
    (humedad tomatera 400)
    (temperatura tomatera 25)
    (luminosidad tomatera 500)

    ; Planta 3: lirio
    (planta lirio 600 400)
    (humedad lirio 400)
    (temperatura lirio 25)
    (luminosidad lirio 500)

    ; Clima para pruebas
    ;(nuevo_clima despejado)
)

; -----------------------------------------------
; Ajusta las temperaturas al nuevo clima:
(defrule CambioClima
    (declare (salience 100))
    ; Debe estar despejado
    ?c <- (nuevo_clima ?clima)

    ; Deben existir datos del clima despejado
    (h ?clima ?h)
    (t ?clima ?t)
    (l ?clima ?l)

    ; Debemos borrar estos hechos así que guardamos sus IDs
    ?bt <- (t_global ?)
    ?bh <- (secado ?)
    ?bl <- (l_global ?)

    =>
    ; Borramos los hechos antiguos
    (retract ?bt)
    (retract ?bh)
    (retract ?bl)
    (retract ?c)

    ; Introducimos los hechos nuevos con los datos del clima
    (assert (t_global ?t))
    (assert (secado ?h))
    (assert (l_global ?l))
    (assert (clima ?clima))
)

; Imprimir datos actuales del clima:
(defrule ImprimirClima
    ; Activación:
    ?d <- (datos_clima)

    ; Datos a imprimir:
    (t_global ?t)
    (secado ?h)
    (l_global ?l)
    =>
    (printout t crlf "Datos del clima:" crlf "Temperatura: " ?t "." crlf "Factor de secado: " ?h "." crlf "Luminosidad: " ?l "." crlf)
    (retract ?d)
)

; -----------------------------------------------
; Detectar que una planta está seca:
(defrule PeligroPlantaSeca
    (planta ?p ?min ?max)
    (humedad ?p ?v)
    (test(> ?v ?min))
    =>
    (assert(peligro_seca ?p))
)

; -----------------------------------------------
; Regar una planta cuando está seca:
(defrule regarPlantaSeca
    ?bb <- (peligro_seca ?p)
    ?h <- (humedad ?p ?v)
    =>
    (bind ?vv (- ?v 10))
    (retract ?h)
    (printout t crlf "Regando " ?p ": humedad " ?vv)
    (assert (humedad ?p ?vv))
    (retract ?bb)
)

; -----------------------------------------------
; Detectar que una planta está ardiendo:
(defrule PeligroPlantaArdiendo
    (planta ?p ? ?)
    (temperatura ?p ?v)
    (t_max ?max)
    (test(>= ?v ?max))
    =>
    (assert (peligro_ardiendo ?p))
)

; -----------------------------------------------
(defrule refrescarPlanta
    ?bb <- (peligro_ardiendo ?p)
    ?h <- (temperatura ?p ?v)
    =>
    (bind ?vv (- ?v 10))
    (retract ?h)
    (printout t crlf "Refrescando " ?p ": temperatura " ?vv)
    (assert (temperatura ?p ?vv))
    (retract ?bb)
)