#' Create a zdog ilssutration
#'
#' @param id Id of the object that will be used for the illustration
#' @param class class of the object. By default it's just set to ID. change
#' if you want to modify it further with CSS
#' @param width,height width and height of the canvas in pixels
#' @background background color
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
#'
#' @return An empty zdog illustration.
#' @export
illustration = function(id,
                        class = id,
                        width = 240,
                        height = 240,
                        background = '#FFDDBB',
                        dragRotate = TRUE,
                        centered = TRUE,
                        zoom = 1,
                        scale = 1,
                        translate = c(x = 0, y = 0, z = 0),
                        rotate = c(x = 0, y = 0, z = 0),
                        resize = TRUE,
                        onResize = NULL,
                        onPrerender = NULL,
                        onDragStart = NULL){

    dependency = htmltools::htmlDependency(
        'zdog',
        src = system.file('zdog',package = 'rdog'),
        version = '1.0',
        script = 'zdog.min.js'
    )

    canvas = htmltools::tags$canvas(id = id, class = class,width=width, height = height, style = glue::glue("background:{background}"))

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
        "let <id> = new Zdog.Illustration({
            element: '#<id>',
            dragRotate: true,
            centered: <tolower(centered)>,
            zoom: <zoom>,
            scale: <scale>,
            translate: {x: <translate['x']>, y: <translate['y']>, z: <translate['z']>},
            rotate: {x: <rotate['x']>, y: <rotate['y']>, z: <rotate['z']>},
            resize: <tolower(resize)>,
            onResize: function(width, height){
            <onResize>
            },
            onPrerender: function(context){
            <onPrerender>
            }


        });",
        .open = '<',.close = '>')

    out = htmltools::tagList(
        dependency,
        canvas,
        illustration
    )

    if(dragRotate){
        renderCode =
            htmltools::tags$script(glue::glue('
                                          function animate(){
                                            <id>.updateRenderGraph();
                                            requestAnimationFrame( animate );
                                          };
                                          animate();',.open = '<',.close = '>'))
    } else{
        renderCode = renderCode =
            htmltools::tags$script(glue::glue('<id>.updateRenderGraph();',.open = '<',.close = '>'))
    }

    output =
        list(objects = out,
         renderCode = renderCode)

    class(out) = append('rdog',class(out))
}
