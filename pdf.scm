(define (recursive-merge-layer-groups inImage inLayers)
  (let* ( 
      (layerCount (car inLayers))
      (layerVector (cadr inLayers))
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
            (recursive-merge-layer-groups inImage (gimp-item-get-children layer))
            (gimp-image-merge-layer-group inImage layer)
          )
        )
      )
    )
  )
)

(define (script-fu-layers-from-groups inImage)
  (begin
    (gimp-image-undo-group-start inImage)
    (recursive-merge-layer-groups inImage (gimp-image-get-layers inImage))
    (gimp-image-undo-group-end inImage)
    (gimp-displays-flush)
  )
)

(script-fu-register
  "script-fu-layers-from-groups"
  "Groupes vers calques"
  "Transformation des groupes de calques visibles en calques (récursif)"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "June 19, 2023"
  "*"
  SF-IMAGE "Image" 0
)

(script-fu-menu-register "script-fu-layers-from-groups" "<Image>/Image")

; --------------------------------------------------------------------
; --------------------------------------------------------------------

(define (script-fu-group-from-layer inImage inItem)
  (gimp-image-undo-group-start inImage)
  (let* ( 
      (itemName (car (gimp-item-get-name inItem)))
      (itemIndex (car (gimp-image-get-item-position inImage inItem)))
      (itemParent (car (gimp-item-get-parent inItem)))
      ;(isChild (< -1 itemParent))
      (newGroup (car (gimp-layer-group-new inImage)))
    )

    (gimp-item-set-name newGroup (string-append "Grp " itemName))
    (gimp-image-insert-layer inImage newGroup itemParent itemIndex)
    (gimp-image-reorder-item inImage inItem newGroup 0)
  )

  (gimp-image-undo-group-end inImage)
  (gimp-displays-flush)
)

(script-fu-register
  "script-fu-group-from-layer"
  "Calque vers nouveau groupe"
  "Création d'un groupe depuis un calque"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "July 05, 2023"
  "*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "script-fu-group-from-layer" "<Image>/Layer")
