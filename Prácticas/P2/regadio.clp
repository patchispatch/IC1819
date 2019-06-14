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
    (t_global 30)
    (l_global 600)
    (secado 0)

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
    (planta tomatera 800 300)
    (humedad tomatera 400)
    (temperatura tomatera 25)
    (luminosidad tomatera 500)

    ; Planta 3: lirio
    (planta lirio 800 300)
    (humedad lirio 400)
    (temperatura lirio 25)
    (luminosidad lirio 500)

    ; Clima para pruebas
    (nuevo_clima despejado)
)

; -----------------------------------------------
; Ajusta las temperaturas al nuevo clima:
(defrule CambioClima
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
; Simulación cutre:
(defrule InicioSimulacionCutre
    (simulacion ?n)
    =>
    (assert(paso 0))
)

; Bucle simulación cutre:
(defrule BucleSimulacionCutre
    (declare (salience -10))
    (not(secar))
    (simulacion ?max)
    ?p <- (paso ?n)
    (test(< ?n ?max))
    =>
    ; Secar las cosas:
    (assert (secar))
    (bind ?nn (+ ?n 1))
    (assert (paso ?nn))
    (retract ?p)
)

; Secar las plantas:
(defrule Secar
    (declare (salience -1))
    (secar)
    (secado ?s)
    (planta ?p ? ?)
    (not(planta_seca ?p))
    (not(borrar_planta_seca))
    ?hh <- (humedad ?p ?v)
    =>
    (bind ?vv (+ ?v ?s))
    (retract ?hh)
    (assert (humedad ?p ?vv))
    (assert (planta_seca ?p))
)

; Borrar estado seco:
(defrule BorrarPrimerSeco
    (declare (salience -5))
    ?p <- (planta_seca ?planta)
    =>
    (retract ?p)
    (assert (borrar_planta_seca))
)

; Borrar estado seco:
(defrule BorrarSeco
    (declare (salience -5))
    ?p <- (planta_seca ?planta)
    (borrar_planta_seca)
    =>
    (retract ?p)
)

; No seguir borrando plantas secas:
(defrule PararBorrarPlantasSecas
    (declare (salience -6))
    ?ss <- (secar)
    ?s <- (borrar_planta_seca)
    =>
    (retract ?s)
    (retract ?ss)
)

; Fin simulación cutre:
(defrule FinSimulacionCutre
    (declare (salience -100))
    ?s <- (simulacion ?max)
    ?p <- (paso ?)
    =>
    (retract ?s)
    (retract ?p)
)

; Borrar los secar:
(defrule BorrarSecar
    (declare (salience -100))
    ?s <- (secar)
    =>
    (retract ?s)
)