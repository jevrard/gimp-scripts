(define (script-fu-passtime-scale-photo-partenaire inImage)
  (let* (
      (width (car (gimp-image-width inImage)))
      (height (car (gimp-image-height inImage)))
      (orientation (if (>= width height) 0 1))
      (delta 0.95)
      (targetW 800)
      (targetH 600)
    )

    (if (or (< width (* targetW delta)) (< height (* targetH delta)))
      (error "L'image est trop petite pour le traitement.")

      (begin
        (cond
          ((= orientation 0)
            (set! width (* height (/ targetW targetH)))
          )

          ((= orientation 1)
            (set! height (* width (/ targetH targetW)))
          )
        )
        
        (gimp-image-resize inImage width height 0 0)
        (gimp-displays-flush)
      )
    )
  )
)

(script-fu-register
  "script-fu-passtime-scale-photo-partenaire"
  "1. Mise à l'échelle de la \"Photo Partenaire\""
  "Change l'échelle de l'image en proportion"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "June 21, 2023"
  "*"
  SF-IMAGE "Image" 0
)

(script-fu-menu-register "script-fu-passtime-scale-photo-partenaire" "<Image>/Passtime")

; --------------------------------------------------------------------
; --------------------------------------------------------------------

(define (export-in-jpeg inImage inDrawable)
  (let* ( 
      (imageFilename (car (gimp-image-get-filename inImage)))
      (imageBaseFilename (unbreakupstr (butlast (strbreakup imageFilename ".")) "."))
      (jpegFilename (string-append imageBaseFilename ".jpg"))
    )
    (file-jpeg-save
      RUN-NONINTERACTIVE 
      inImage
      inDrawable
      jpegFilename
      jpegFilename
      0.9 ; quality
      0 ; smoothing
      1 ; optimize
      1 ; progressive
      "" ; comment
      2 ; subsmp 2 == 4:4:4 (best quality)
      0 ; baseline
      0 ; restart
      0; DCT
    ) ; values are default ones
  )
)

(define (script-fu-passtime-export-photo-partenaire inImage inDrawable)
  (gimp-image-scale inImage 800 600)
  (gimp-layer-resize-to-image-size inDrawable)
  (export-in-jpeg inImage inDrawable)
  (gimp-displays-flush)
  (gimp-image-clean-all inImage)
)

(script-fu-register
  "script-fu-passtime-export-photo-partenaire"
  "2. Exporter une \"Photo Partenaire\""
  "Change l'échelle de l'image en 800x600px et exporte au format JPEG (.jpg)"
  "jevrard"
  "Copyright (c) 2023 jevrard"
  "June 15, 2023"
  "*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
)

(script-fu-menu-register "script-fu-passtime-export-photo-partenaire" "<Image>/Passtime")