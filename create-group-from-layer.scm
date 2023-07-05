(define (script-fu-group-from-layer image layer)
  (gimp-image-undo-group-start image)
  (let
    (
      (layerName (car (gimp-item-get-name layer)))
      (layerIndex (car (gimp-image-get-item-position image layer)))
      (layerParent (car (gimp-item-get-parent layer)))
      (newGroup (car (gimp-layer-group-new image)))
    )

    (gimp-item-set-name newGroup (string-append "GRP " layerName))
    (gimp-image-insert-layer image newGroup layerParent layerIndex)
    (gimp-image-reorder-item image layer newGroup 0)
  )

  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
)

(script-fu-register
  "script-fu-group-from-layer"
  "Créer un groupe depuis le calque"
  "Création d'un groupe autour du calque actif"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "July 05, 2023"
  "*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "script-fu-group-from-layer" "<Image>/Layer")