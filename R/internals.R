#' Common shape arguments
#' @keywords internal
#' @name shape
#'
#' @param color Color of the shape. A color string.
#' @param stroke Width of the shape line. 0 will make it invisible
#' @param fill Logical. Fill the inner shape area
#' @param closed Logical. Should the first point and the last be connected
#' @param visible Logical. Is the shape visible.
#' @param backface Logical. Should backface be visible or a color string to set a different
#' color
#' @param front. Determine where the front of the shape is to decide rendering backface color.
#' A vector with named x, y, z elements.
internal_shape = function(
    color = '#333',
    stroke = 1,
    fill = TRUE,
    closed = TRUE,
    visible = TRUE,
    backface = TRUE,
    front = c(z = 1)
){
    assertthat::assert_that(assertthat::is.string(color))
    assertthat::assert_that(assertthat::is.number(stroke))
    assertthat::assert_that(is.logical(fill))
    assertthat::assert_that(is.logical(closed))
    assertthat::assert_that(is.logical(visible))
    assertthat::assert_that(is.logical(backface) | assertthat::is.string(backface))

    glue::glue(
        'color: "<color>",
        stroke: <stroke>,
        fill: <tolower(fill)>,
        closed: <tolower(closed)>,
        visible: <tolower(visible)>,
        backface: <if(is.logical(backface)){tolower(backface)}else{paste0("\'",backface,"\'")}>,
        front: <process_coord_vector(front)>',
        .close = '>',.open = '<')

}

#' Common anchor arguments
#' @keywords internal
#' @name anchor
#'
#' @param addTo Id of the parent object. If an rdog object is piped and
#' addTo is set to NULL, the default parent will be the illustration itself.
#' @param translate Position relative to the origin. Origin point is defined based
#' on \code{addTo} parameter. A vector with named x, y, z elements.
#' @param rotate Set rotation. Unit is radians. Use with \code{\link[base]{pi}} constant. A vector with named x, y, z elements.
#' @param scale Scale dimensons. Can be an unnamed integer or a vector with named x, y ,z elements
internal_anchor = function(
    addTo,
    translate = c(x =0, y=0,z=0),
    rotate = c(x = 0, y = 0, z = 0),
    scale = c(x = 1, y = 1, z = 1)
){

    glue::glue(
        'addTo: <addTo>,
        translate: <process_coord_vector(translate)>,
        rotate: <process_coord_vector(rotate)>,
        scale: <process_coord_vector(scale,allowSingle=TRUE,default=1)>',
        .close = '>',.open = '<')

}

process_coord_vector = function(vector,default = 0, allowSingle = FALSE){
    if(length(vector)==1 && allowSingle && is.null(names(vector))){
        return(vector)
    }
    coords = c('x','y','z')

    assertthat::assert_that(any(coords %in% names(vector)) &
                                all(names(vector) %in% coords),
                            msg = glue::glue("{as.character(substitute(vector))} requires a vector with names x, y and z"))

    vector[coords[!coords %in% names(vector)]] = default

    glue::glue('{x: <vector["x"]>, y: <vector["y"]>, z: <vector["z"]>}',
               .close = '>',.open = '<')

}




#' @export
print.rdog = function(rdog, ...){
    toPrint = htmltools::tagList(# htmltools::tags$script('Zfont.init(Zdog);'),
                                 rdog,
                                 htmltools::tags$script(glue::glue('{attributes(rdog)$id}.updateRenderGraph();')))


    htmltools::html_print(toPrint)
}

# FPS has to be a multiple of 10
#' @export
record_gif = function(rdog,file = NULL, duration = 3){

    www_dir <- tempfile("viewhtml")
    dir.create(www_dir)
    index_html <- file.path(www_dir, "index.html")
    htmltools::save_html(rdog, file = index_html,
                         background = paste0(attributes(rdog)$background,';margin: 0'),
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



    b <- chromote::ChromoteSession$new(width = attributes(rdog)$width+4, height = attributes(rdog)$height+4)
    frames <- list()
    currentFrame = environment()
    cancel_save_screencast_frames <- b$Page$screencastFrame(callback_ = function(value) {
        framesLocal = frames
        framesLocal[[length(framesLocal) + 1]] <- value
        assign('frames',framesLocal,envir = currentFrame)
        cat(".")
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

    animation = images %>% lapply(magick::image_read) %>% do.call(c,.) %>%
        magick::image_crop(glue::glue('{attributes(rdog)$width}x{attributes(rdog)$height}')) %>%
        magick::image_animate(fps = 10)

    if(!is.null(file)){
        magick::image_write(animation,file)
    }

    return(animation)

}
