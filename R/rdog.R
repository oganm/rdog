#' @export
tau = 2*pi

#' Create a zdog ilssutration
#'
#' @param id Id of the object that will be used for the illustration
#' @param class class of the canvas. By default it's just set to ID. change
#' @param canvasID id of the canvas where the shapes will be drawn.
#' if you want to modify it further with CSS
#' @param width,height width and height of the canvas in pixels
#' @param background background color
#' @param dragRotate enable drag rotation on the canvas. Could also be the
#' name of an object three for which the rotation will be enabled.
#' @param centered If TRUE, the x = 0, y = 0 will be the center of the figure,
#' if FALSE x = 0 y= 0 will be the upper left corner
#' @param zoom Enlarge or shring the displayed size.
#' @param scale Enlarge or shrink item geometry. Unlike zoom, it won't effect srokes
#' (if set to 2 objects will be larger but no thicker)
#' @param translate Named vector. Positition the entire image within the canvas. (Effectively moves the origin point)
#' @param rotate Named vector. Rotation applied to the entire image in radians.
#' @param resize Allow fluid element resizing
#' @param onResize javascript code to execute on resize, requires resize = TRUE. width and height is passed
#' into the function.
#' @param onPrerender javascript code to execute on pre-render. canvas
#' context will be passed as \code{context}
#' @param onDragStart javascript code to execute on drag start.
#' @param displayType type of display. canvas or svg
#'
#' @return An empty zdog illustration.
#' @export
illustration = function(id = NULL,
                        class = id,
                        canvasID = id,
                        width = 240,
                        height = 240,
                        background = '#FFDDBB',
                        dragRotate = TRUE,
                        centered = TRUE,
                        zoom = 1,
                        scale = 1,
                        translate = c(x = 0, y = 0, z = 0),
                        rotate = c(x = 0, y = 0, z = 0),
                        resize = FALSE,
                        onResize = NULL,
                        onPrerender = NULL,
                        onDragStart = NULL,
                        displayType = c('canvas', 'svg')){

    displayType = match.arg(displayType)


    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }


    assertthat::assert_that(is.logical(dragRotate) | is.character(dragRotate))
    if(is.logical(dragRotate)){
        dragRotate = tolower(dragRotate)
    }

    assertthat::assert_that(is.logical(centered))
    assertthat::is.number(zoom)
    assertthat::is.number(scale)
    assertthat::assert_that(is.numeric(translate))
    assertthat::assert_that(is.numeric(rotate))
    assertthat::assert_that(is.logical(resize))

    if(is.null(onResize)){
        onResize = ''
    }
    if(is.null(onPrerender)){
        onPrerender = ''
    }
    if(is.null(onDragStart)){
        onDragStart = ''
    }

    illustration = glue::glue(
        "
        <id> = new Zdog.Illustration({
            element: '#<canvasID>',
            dragRotate: <tolower(dragRotate)>,
            centered: <tolower(centered)>,
            zoom: <zoom>,
            scale: <process_coord_vector(scale,allowSingle=TRUE,default=1)>,
            translate: <process_coord_vector(translate)>,
            rotate: <process_coord_vector(rotate)>,
            resize: <tolower(resize)>,
            onResize: function(width, height){
            <onResize>
            },
            onPrerender: function(context){
            <onPrerender>
            }
        });",
        .open = '<',.close = '>')


    x <- list(
        jsCode = illustration,
        canvasID = canvasID,
        illId = id,
        width = width,
        height = height,
        background = background,
        components = list(),
        fonts = list(),
        displayType = displayType,
        centered = centered,
        zoom = zoom,
        scale = scale,
        translate = as.list(translate),
        rotate = as.list(rotate),
        resize = resize
    )

    # create the widget
    out = htmlwidgets::createWidget("zdog", x, width = width, height = height, package='rdog',
                              sizingPolicy = htmlwidgets::sizingPolicy(
                                  padding = 0,
                                  viewer.padding = 0
                              ))


    return(out)
}



