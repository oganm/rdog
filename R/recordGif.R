#' Record a gif from an illustration
#'
#' @param rdog rdog object
#' @param file output file path for the gif file
#' @param duration seconds to record
#'
#' @export
record_gif = function(rdog,file = NULL, duration = 3){

    tags = htmltools::as.tags(rdog, standalone = TRUE)

    www_dir <- tempfile("viewhtml")
    dir.create(www_dir)
    index_html <- file.path(www_dir, "index.html")
    htmltools::save_html(tags, file = index_html,
                         background = paste0(rdog$x$background,';margin: 0'),
                         libdir = "lib")

    imageDir = tempfile()
    dir.create(imageDir)

    # frames = seq(from = 0 , to = duration, by = 1/fps)
    #
    # for(i in seq_along(frames)){
    #     a = FALSE
    #     while(!a){
    #         a = tryCatch({
    #             suppressMessages(
    #             webshot(paste0(index_html),
    #                               file = glue::glue('{imageDir}/{i}.png'),
    #                               selector = glue::glue('.{attributes(rdog)$id}'),
    #                               delay = frames[i])
    #             )
    #             TRUE
    #         }, error = function(e){
    #             FALSE
    #         })
    #     }
    # }
    #
    # images = paste0(imageDir,'/',seq_along(frames),'.png')
    #
    # animation = images %>% lapply(magick::image_read) %>% do.call(c,.) %>%
    #     magick::image_animate(fps = fps)
    #
    # if(!is.null(file)){
    #     magick::image_write(animation,file)
    # }
    #
    # return(animation)



    b <- chromote::ChromoteSession$new(width = rdog$x$width + 4, height = rdog$x$height + 4)
    frames <- list()
    currentFrame = environment()
    cancel_save_screencast_frames <- b$Page$screencastFrame(callback_ = function(value) {
        framesLocal = frames
        framesLocal[[length(framesLocal) + 1]] <- value
        assign('frames',framesLocal,envir = currentFrame)
    })

    # You'll need to provide the correct file path
    b$Page$navigate(paste0('file://',index_html))

    b$Page$startScreencast(format = "png", everyNthFrame = 1)
    Sys.sleep(duration)
    b$Page$stopScreencast()
    cancel_save_screencast_frames()


    lapply(seq_along(frames), function(i) {
        writeBin(jsonlite::base64_dec(frames[[i]]$data), glue::glue('{imageDir}/{i}.png'))
    })

    # Record for 5 seconds, then stop.
    # later::later(
    #     function() {
    #         b$Page$stopScreencast()
    #         cancel_save_screencast_frames()
    #
    #         lapply(seq_along(frames), function(i) {
    #             writeBin(jsonlite::base64_dec(frames[[i]]$data), glue::glue('{imageDir}/{i}.png'))
    #         })
    #         b$close()
    #         message("done")
    #     },
    #     duration
    # )

    images = paste0(imageDir,'/',seq_along(frames)[-(1:3)],'.png')

    animation = images %>%
        lapply(function(x){gc();magick::image_read(x)}) %>%
        do.call(c,.) %>%
        magick::image_crop(glue::glue('{rdog$x$width}x{rdog$x$height}')) %>%
        magick::image_animate(fps = 10)

    if(!is.null(file)){
        magick::image_write(animation,file)
    }

    gc()

    return(animation)

}


#' Save an image from an illustration
#'
#' @param rdog rdog object
#' @param file output file path for the image file
#'
#' @export
save_image = function(rdog, file = NULL){

    tags = htmltools::as.tags(rdog, standalone = TRUE)

    www_dir <- tempfile("viewhtml")
    dir.create(www_dir)
    index_html <- file.path(www_dir, "index.html")
    htmltools::save_html(tags, file = index_html,
                         background = paste0(rdog$x$background,';margin: 0'),
                         libdir = "lib")

    # b <- chromote::ChromoteSession$new(width = rdog$x$width + 4, height = rdog$x$height + 4)

   #  b$Page$navigate(paste0('file://',index_html))

    if(is.null(file)){
        file = tempfile(fileext = '.png')
    }

    webshot2::webshot(index_html,file = file)

    img = magick::image_read(file) %>% magick::image_crop(glue::glue('{rdog$x$width}x{rdog$x$height}'))

    if(!is.null(file)){
        magick::image_write(img,file)
    }

    gc()
    return(img)

}
