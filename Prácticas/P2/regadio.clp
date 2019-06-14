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
    (h_global 450)
    (l_global 600)

    ; -------------------------------------------
    ; Datos de los climas.
    ; Despejado:
    (h_despejado 5)
    (t_despejado 23)
    (l_despejado 1000)

    ; Nublado:
    (h_nublado -5)
    (t_nublado 18)
    (l_nublado 800)

    ; Árido:
    (h_arido 20)
    (t_arido 35)
    (l_arido 2000)

    ; Lluvioso:
    (h_lluvioso -20)
    (t_lluvioso 15)
    (l_lluvioso 500)

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
)

; -----------------------------------------------
; Ajusta las temperaturas al clima actual.
; Despejado:
(defrule ClimaDespejado
    ; Debe estar despejado
    ?c <- (clima despejado)

    ; Deben existir datos del clima despejado
    (h_despejado ?h)
    (t_despejado ?t)
    (l_despejado ?l)

    ; Debemos borrar estos hechos así que guardamos sus IDs
    ?bt <- (t_global ?)
    ?bh <- (h_global ?)
    ?bl <- (l_global ?)

    =>
    ; Borramos los hechos antiguos
    (retract ?bt)
    (retract ?bh)
    (retract ?bl)
    (retract ?c)

    ; Introducimos los hechos nuevos con los datos del clima
    (assert (t_global ?t))
    (assert (h_global ?h))
    (assert (l_global ?l))
    (assert (despejado))
)

; Nublado:
(defrule ClimaNublado
    ; Debe estar nublado
    (clima nublado)

    ; Deben existir datos del clima nublado
    (h_nublado ?h)
    (t_nublado ?t)
    (l_nublado ?l)

    ; Debemos borrar estos hechos así que guardamos sus IDs
    ?bt <- (t_global ?)
    ?bh <- (h_global ?)
    ?bl <- (l_global ?)

    =>
    ; Borramos los hechos antiguos
    (retract ?bt)
    (retract ?bh)
    (retract ?bl)

    ; Introducimos los hechos nuevos con los datos del clima
    (assert (t_global ?t))
    (assert (h_global ?h))
    (assert (l_global ?l))
)

; Árido:
(defrule ClimaArido
    ; Debe estar árido
    (clima arido)

    ; Deben existir datos del clima árido
    (h_arido ?h)
    (t_arido ?t)
    (l_arido ?l)

    ; Debemos borrar estos hechos así que guardamos sus IDs
    ?bt <- (t_global ?)
    ?bh <- (h_global ?)
    ?bl <- (l_global ?)

    =>
    ; Borramos los hechos antiguos
    (retract ?bt)
    (retract ?bh)
    (retract ?bl)

    ; Introducimos los hechos nuevos con los datos del clima
    (assert (t_global ?t))
    (assert (h_global ?h))
    (assert (l_global ?l))
)

; Lluvioso:
(defrule ClimaLluvioso
    ; Debe estar lluvioso
    (clima lluvioso)

    ; Deben existir datos del clima lluvioso
    (h_lluvioso ?h)
    (t_lluvioso ?t)
    (l_lluvioso ?l)

    ; Debemos borrar estos hechos así que guardamos sus IDs
    ?bt <- (t_global ?)
    ?bh <- (h_global ?)
    ?bl <- (l_global ?)

    =>
    ; Borramos los hechos antiguos
    (retract ?bt)
    (retract ?bh)
    (retract ?bl)

    ; Introducimos los hechos nuevos con los datos del clima
    (assert (t_global ?t))
    (assert (h_global ?h))
    (assert (l_global ?l))
)

; Imprimir datos actuales del clima:
(defrule ImprimirClima
    ; Activación:
    ?d <- (datos_clima)

    ; Datos a imprimir:
    (t_global ?t)
    (h_global ?h)
    (l_global ?l)
    =>
    (printout t crlf "Datos del clima:" crlf "Temperatura: " ?t "." crlf "Humedad: " ?h "." crlf "Luminosidad: " ?l "." crlf)
    (retract ?d)
)