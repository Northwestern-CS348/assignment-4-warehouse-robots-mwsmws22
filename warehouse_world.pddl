(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?from - location ?to - location ?r - robot)
      :precondition (and (at ?r ?from) (no-robot ?to) (connected ?from ?to))
      :effect (and (not (at ?r ?from)) (at ?r ?to) (no-robot ?from) (not (no-robot ?to)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?from - location ?to - location ?r - robot  ?p - pallette)
      :precondition (and (at ?r ?from) (at ?p ?from) (no-robot ?to) (no-pallette ?to) (connected ?from ?to))
      :effect (and (not (at ?r ?from)) (not (at ?p ?from)) (at ?r ?to) (at ?p ?to) (no-robot ?from) (no-pallette ?from) (not (no-robot ?to)) (not (no-pallette ?to)))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location  ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (started ?s) (orders ?o ?si) (contains ?p ?si) (at ?p ?l) (available ?l))
      :effect (and (not (contains ?p ?si)) (not (available ?l)) (includes ?s ?si) (packing-at ?s ?l))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (packing-at ?s ?l) (ships ?s ?o))
      :effect (and (not (packing-at ?s ?l)) (complete ?s) (available ?l))
   )
)