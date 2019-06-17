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

    ; -------------------------------------------
    ; Datos del ambiente al inicio.
    (t_global 80)
    (l_global 600)
)

; -----------------------------------------------
; Añadir un nuevo cultivo:
(defrule AddCultivo
    (declare (salience 500))
    ?a <- (add)
    =>
    (printout t crlf "Introduce los datos de tu planta en este formato: nombre humedad_min humedad_max temperatura_max" crlf)
    (bind ?datos (explode$ (readline)))
    (assert (planta ?datos))
    (assert (nueva_planta ?datos))
    (retract ?a)
)

(defrule NuevaPlanta
    (declare (salience 500))
    ?n <- (nueva_planta ?nombre ?h_min ?h_max ?)
    (t_global ?t)
    (l_global ?l)
    =>
    (assert(humedad ?nombre ?h_max))
    (assert(temperatura ?nombre ?t))
    (assert(luminosidad ?nombre ?l))
    (retract ?n)
)

; -----------------------------------------------
; Imprimir datos de un cultivo:
(defrule DatosCultivo
    (declare (salience 500))
    ?d <- (datos ?planta)
    (planta ?planta ?h_min ?h_max ?t_max)
    (humedad ?planta ?h)
    (temperatura ?planta ?t)
    (luminosidad ?planta ?l)
    =>
    (printout t crlf "Datos de la planta " ?planta ":" crlf "Temperatura: " ?t "." crlf "Humedad: " ?h "." crlf "Luminosidad: " ?l "." crlf "Humedad mínima: " ?h_min "." crlf "Humedad máxima: " ?h_max "." crlf "Temperatura máxima: " ?t_max "." crlf )
    (retract ?d)
)

; -----------------------------------------------
; Cambiar el horario de riego:
(defrule NuevoHorarioRiego
    (declare (salience 500))
    ?n <- (nuevo_horario ?inicio ?fin)
    ?o <- (horario_riego ? ?)
    =>
    (retract ?o)
    (assert (horario_riego ?inicio ?fin))
    (retract ?n)
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
    (not (clima_siguiente lluvioso))
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
    (test(> ?v (+ ?min 150)))
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

; -----------------------------------------------
; Activar posibilidad de riego normal:
(defrule PermitidoRegar
    (hora ?n)
    (horario_riego ?h1 ?h2)
    (test (>= ?h1 ?n))
    =>
    (assert (permitido_regar))
)

; -----------------------------------------------
; Desactivar posibilidad de riego normal:
(defrule NoPermitidoRegar
    (hora ?n)
    (horario_riego ?h1 ?h2)
    (test (>= ?h2 ?n))
    ?p <- (permitido_regar)
    =>
    (retract ?p)
)