(define (set-visibility-only-on-layer layer layers visibility)
  (let
    (
      (layersCount (car layers))
      (layersVector (cadr layers))
      (reverseVisibility (if (< 0 visibility) 0 1))
    )

    (while (< 0 layersCount)
      (set! layersCount (- layersCount 1))
      (gimp-item-set-visible (vector-ref layersVector layersCount) reverseVisibility)
    )
    (if (< (car (gimp-item-get-parent layer)) 0)
      (gimp-item-set-visible layer visibility)
      #f
    )
  )
)

(define (script-fu-other-layers-visibile image layer)
  (gimp-image-undo-group-start image)
  (set-visibility-only-on-layer layer (gimp-image-get-layers image) 0)
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
)

(script-fu-register
  "script-fu-other-layers-visibile"
  "Activer tous les autres calques"
  "Active tous les calques de premier niveau sauf celui sélectionné"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "July 15, 2023"
  "*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "script-fu-other-layers-visibile" "<Image>/Image")

(define (script-fu-other-layers-not-visibile image layer)
  (gimp-image-undo-group-start image)
  (set-visibility-only-on-layer layer (gimp-image-get-layers image) 1)
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
)

(script-fu-register
  "script-fu-other-layers-not-visibile"
  "Masquer tous les autres calques"
  "Masque tous les calques de premier niveau sauf celui sélectionné"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "July 15, 2023"
  "*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "script-fu-other-layers-not-visibile" "<Image>/Image")