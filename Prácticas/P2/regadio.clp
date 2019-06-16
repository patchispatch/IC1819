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
    (planta cactus 800 300 40)
    (humedad cactus 400)
    (temperatura cactus 25)
    (luminosidad cactus 500)

    ; Planta 2: tomatera
    (planta tomatera 500 250 30)
    (humedad tomatera 400)
    (temperatura tomatera 25)
    (luminosidad tomatera 500)

    ; Planta 3: lirio
    (planta lirio 600 400 28)
    (humedad lirio 400)
    (temperatura lirio 25)
    (luminosidad lirio 500)

    ; -------------------------------------------
    ; Horario de riego:
    (horario_riego 2 8)
)


; -----------------------------------------------
; Detectar que una planta está seca:
(defrule PeligroPlantaSeca
    (planta ?p ?min ?max ?)
    (humedad ?p ?v)
    (test(> ?v ?min))
    =>
    (assert(peligro_seca ?p))
)

; -----------------------------------------------
; Regar una planta:
(defrule regarPlantaSeca
    ?bb <- (peligro_seca ?p)
    (planta ?p ?min ?max ?)
    ?h <- (humedad ?p ?v)
    (permitido_regar)
    =>
    (bind ?vv (/ (+ ?min ?max) 2))
    (retract ?h)
    (printout t crlf "Regando " ?p ": humedad " ?vv)
    (assert (humedad ?p ?vv))
    (retract ?bb)
)

; -----------------------------------------------
; Detectar que una planta está alarmantemente seca:
(defrule EmergenciaPlantaSeca
    (planta ?p ?min ?max ?)
    (humedad ?p ?v)
    (test(> ?v (+ ?min 150))
    =>
    (assert(emergencia_seca ?p))
)

; -----------------------------------------------
; Efectuar un regado de emergencia:
(defrule RegadoDeEmergencia
    ?bb <- (emergencia_seca ?p)
    (planta ?p ?min ?max ?)
    ?h <- (humedad ?p ?v)
    =>
    (bind ?vv ?max)
    (retract ?h)
    (printout t crlf "Regado de emergencia " ?p ": humedad " ?vv)
    (assert (humedad ?p ?vv))
    (retract ?bb)
)

; -----------------------------------------------
; Detectar que una planta está ardiendo:
(defrule PeligroPlantaArdiendo
    (planta ?p ? ? ?max)
    (temperatura ?p ?v)
    (test(>= ?v ?max))
    =>
    (assert (peligro_ardiendo ?p))
)

; -----------------------------------------------
; Refrescar una planta cuando está ardiendo:
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