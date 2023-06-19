(define (recursive-merge-layer-groups image layers)
  (let
    (
      (layerCount (car layers))
      (layerVector (cadr layers))
    )

    (while (< 0 layerCount)
      (let*
        (
          (layer (vector-ref layerVector (set! layerCount (- layerCount 1))))
          (isGroup (= 1 (car (gimp-item-is-group layer))))
          (isVisible (= 1 (car (gimp-item-get-visible layer))))
        )

        (cond
          ((and isGroup isVisible)
            (recursive-merge-layer-groups image (gimp-item-get-children layer))
            (gimp-image-merge-layer-group image layer)
          )
        )
      )
    )
  )
)

(define (script-fu-layers-from-groups image)
  (gimp-image-undo-group-start image)
  (recursive-merge-layer-groups image (gimp-image-get-layers image))
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
)

(script-fu-register
  "script-fu-layers-from-groups"
  "Groupes vers calques"
  "Transformation des groupes de calques visibles de premier niveau en calques (récursif)"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "June 19, 2023"
  "*"
  SF-IMAGE "Image" 0
)

(script-fu-menu-register "script-fu-layers-from-groups" "<Image>/Image")