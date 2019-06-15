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
)

; -----------------------------------------------
; Ajusta las temperaturas al nuevo clima:
(defrule CambioClima
    (declare (salience 100))
    ?c <- (nuevo_clima ?clima)
    =>
    ; Borramos
    (retract ?c)

    ; Introducimos el nuevo clima:
    (assert (clima ?clima))
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