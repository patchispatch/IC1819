; #############################################################################
; INGENIERÍA DEL CONOCIMIENTO
; PRÁCTICA 1: REPRESENTACIÓN DEL PLANO DE UNA CASA EN CLIPS
; AUTOR: JUAN OCAÑA VALENZUELA
; GRADO EN INGENIERÍA INFORMÁTICA, CURSO 2018/2019
;
; rooms.clp
; -----------------------------------------------------------------------------
; En esta práctica se ha escogido un plano de una vivienda, y se pretende
; representar la misma de cara a que un sistema experto para el control de
; la domótica de la casa pueda saber el número de habitaciones y cómo están
; conectadas. Este archivo define los hechos necesarios para representar las
; diferentes habitaciones.
;
; La casa está compuesta de las siguientes habitaciones:
;  - Salón (lroom)
;  - Cocina (kitchen)
;  - Baño (bath)
;  - Pasillo (corridor)
;  - Despacho (office)
;  - Habitación grande (big)
;  - Habitación mediana (medium)
;  - Habitación pequeña (small)
;  - Entrada (hall)
;  - Patio (courtyard)
;  - Terraza 1 (terrace_1)
;  - Terraza 2 (terrace_2)
;
; Las habitaciones se definirán como hechos de la siguiente forma:
;    (room <room_id>)
;
; También se considerarán las puertas, pasos y ventanas asociadas
; a las mismas. Consideraremos que las puertas y los pasos unen dos
; habitaciones, y las ventanas pertenecen a una habitación. Todos
; estos elementos estarán identificados por su ID.
;
; Las definiremos de la siguiente forma:
;    (door <door_id> <room_id_1> <room_id_2>)
;    (window <window_id> <room_id>)
;    (passage <pass_id> <room_id_1> <room_id_2>)
;
; #############################################################################

; Definición de habitaciones:
(deffacts rooms
  (room lroom)
  (room kitchen)
  (room bath)
  (room corridor)
  (room office)
  (room big)
  (room medium)
  (room small)
  (room hall)
  (room courtyard)
  (room terrace_1)
  (room terrace_2)
)

; Definición de las puertas:
(deffacts doors
  (door terr1_kitchen terrace_1 kitchen)
  (door terr1_lroom terrace_1 lroom)
  (door kitchen_corridor kitchen corridor)
  (door bath_corridor bath corridor)
  (door office_corridor office corridor)
  (door medium_corridor medium corridor)
  (door big_corridor big corridor)
  (door small_corridor small corridor)
  (door entrance_corridor entrance corridor)
  (door courtyard_corridor courtyard corridor)
  (door entrance_courtyard entrance courtyard)
  (door entrance_outside entrance outside)
)

; Definición de los pasos:
(deffacts passages
  (passage terr2_courtyard terrace_2 courtyard)
  (passage lroom_corridor lroom corridor)
)

; Definición de las ventanas:
(deffacts windows
  (window w_entrance entrance)
  (window w_small small)
  (window w_big big)
  (window w_terr2 terrace_2)
  (window w_lroom lroom)
  (window w_kitchen kitchen)
  (window w_terr1 terrace_1)
)

; Definición de reglas:

; Se puede acceder de una habitación a otra a través de una puerta:
(defrule posible_pasar_puerta
  (door ?door_id ?room_1 ?room_2)
  =>
  (assert(posible_pasar ?room_1 ?room_2))
)

; Se puede acceder de una habitación a otra a través de un paso:
(defrule posible_pasar_paso
  (passage ?passage_id ?room_1 ?room_2)
  =>
  (assert(posible_pasar ?room_1 ?room_2))
)

; La habitación es interior:
(defrule habitacion_interior
  (room ?room_id)
  (window ?window_id ?room_id)
  =>
  (assert(habitacion_interior ?room_id))
)

; Imprimir por pantalla el resultado:
(defrule print_posible_pasar
  (posible_pasar ?room_1 ?room_2)
  =>
  (printout t crlf "Posible pasar de " ?room_1 " a " ?room_2)
)

(defrule print_habitacion_interior
  (habitacion_interior ?room_id)
  =>
  (printout t crlf "La habitación " ?room_id " es exterior")
)
