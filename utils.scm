; --------------------------------------------------------------------
; --------------------------------------------------------------------

(define (util-get-base-filename filename)
  (unbreakupstr (butlast (strbreakup filename ".")) ".")
)

; --------------------------------------------------------------------
; --------------------------------------------------------------------

; 1 inch = 25.4 mm
(define inch-in-mm 25.4)

; pixels = millimeters * ((ppi resolution) / (1 inch in mm))
(define (converter-mm-to-px mm ppi)
  (* mm (/ ppi inch-in-mm))
)

; millimeters = pixels * ((1 inch in mm) / (ppi resolution))
(define (converter-px-to-mm pixels ppi)
  (* pixels (/ inch-in-mm ppi))
)