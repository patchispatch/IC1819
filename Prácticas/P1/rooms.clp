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
;
; Como el sistema tiene que poder deducir qué habitaciones son exteriores, 
; añadiremos la "habitación exterior":
;  - Exterior (outside)
;
; Los hechos para representar habitaciones tendrán la siguiente estructura:
; (room <nombre_hab> <hab_conectadas>)
;
; ############################################################################# 

; Definición de la plantilla de habitación:
(deftemplate room
   (field name)
   (multifield connected_rooms)
)

; Definición de las habitaciones de nuestra casa:
(deffacts rooms
   ; Salón:
   (room
      (name lroom)
      (connected_rooms corridor outside)
   )

   ; Cocina:
   (room
      (name kitchen)
      (connected_rooms corridor outside)
   )

   ; Baño:
   (room
      (name bath)
      (connected_rooms corridor)
   )

   ; Pasillo:
   (room
      (name corridor)
      (connected_rooms courtyard office medium bath lroom kitchen hall)
   )

   ; Despacho:
   (room
      (name office)
      (connected_rooms corridor)
   )

   ; Habitación grande:
   (room
      (name big)
      (connected_rooms hall)
   )
   
   ; Habitación mediana:
   (room
      (name medium)
      (connected_rooms corridor)
   )

   ; Habitación pequeña:
   (room
      (name small)
      (connected_rooms hall)
   )

   ; Entrada:
   (room
      (name hall)
      (connected_rooms corridor small big courtyard outside)
   )

   ; Patio:
   (room
      (name courtyard)
      (connected_rooms corridor hall)
   )
)