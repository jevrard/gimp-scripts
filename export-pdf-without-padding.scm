(define (script-fu-export-pdf-without-padding image paddingX paddingY suffix)
  (let*
    (
      (dpi (gimp-image-get-resolution image))
      (dpiX (car dpi))
      (dpiY (cadr dpi))
    )

    (set! paddingX (if (integer? paddingX) (converter-mm-to-px paddingX dpiX) 0))
    (set! paddingY (if (integer? paddingY) (converter-mm-to-px paddingY dpiY) 0))
    (set! suffix (if (< 0 (string-length suffix)) (string-append " " suffix) ""))
  )

  (let*
    (
      (copy (car (gimp-image-duplicate image)))
      (layers (gimp-image-get-layers copy))
      (imageWidth (car (gimp-image-width copy)))
      (imageHeight (car (gimp-image-height copy)))
      (newWidth (- imageWidth (* paddingX 2)))
      (newHeight (- imageHeight (* paddingY 2)))
      (offsetX (- 0 paddingX))
      (offsetY (- 0 paddingY))
      (baseFilename (util-get-base-filename (car (gimp-image-get-filename image))))
      (pdfFilename (string-append (string-append baseFilename suffix) ".pdf"))
    )

    (recursive-merge-layer-groups copy layers)
    (gimp-image-resize copy newWidth newHeight offsetX offsetY)
    (file-pdf-save2
      RUN-NONINTERACTIVE
      copy
      (vector-ref (cadr (gimp-image-get-layers copy)) 0)
      pdfFilename
      pdfFilename
      1 ; vectorize
      1 ; ignore-hidden
      1 ; apply-masks
      1 ; layers-as-pages
      1 ; reverse-order
      )
    (gimp-image-clean-all copy)
    (gimp-image-delete copy)
  )
)

(script-fu-register
  "script-fu-export-pdf-without-padding"
  "Exporter sans les marges"
  "Exporte le fichier en PDF sans les marges d'impression"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "July 16, 2023"
  "*"
  SF-IMAGE "Image" 0
  SF-VALUE "Marge X (en mm)" ""
  SF-VALUE "Marge Y (en mm)" ""
  SF-STRING "Suffix du nom du fichier" ""
)

(script-fu-menu-register "script-fu-export-pdf-without-padding" "<Image>/File/PDF")