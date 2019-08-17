
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


process_id_inputs = function(rdog, addTo, id){
    if(is.null(addTo) && !is.character(rdog)){
        addTo = rdog$x$illId
    } else if(is.null(addTo) && is.character(rdog)){
        addTo = rdog
    } else if(is.null(addTo) && is.null(rdog)){
        stop('Both addTo and rdog is left blank')
    }

    if(is.null(rdog)){
        illoId = NULL
    } else if(assertthat::is.string(rdog)){
        illoId = rdog
    } else if('htmlwidget' %in% class(rdog)){
        illoId = rdog$x$illId
    }

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    return(list(addTo, id, illoId))
}
