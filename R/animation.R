#' No animation
#'
#' Just establishes the animation loop without actually moving anything. This
#' is required if you called \code{\link{illustration}} with dragRotate = TRUE
#'
#' @export
animation_none = function(rdog = NULL,id = NULL){


    if(!is.null(rdog)){
        parentAttributes = attributes(rdog)
        id = parentAttributes$id
    }

    animationScript = glue::glue(
        'function animate_<id>(){
        <parentAttributes$id>.updateRenderGraph();
        requestAnimationFrame( animate_<id> );
        }
        animate_<id>()',
        .open = '<',.close = '>'
    )

    out = htmltools::tagList(rdog,
                             htmltools::tags$script(animationScript))

    newAttributes = c(parentAttributes,
                      animation = 'none')
    attributes(out) = newAttributes

    return(out)

}

#' Custom animation
#'
#' Use your own javascript code to animate
animation_custom = function(rdog, customJS,...){

}

#' @export
animation_rotate = function(rdog = NULL,
                            animateID = NULL,
                            rotate = c(x = 0, y = 0, z = 0)){

    if(!is.null(rdog)){
        parentAttributes = attributes(rdog)
        id = parentAttributes$id
    }

    coords = c('x','y','z')
    rotate[coords[!coords %in% names(rotate)]] = 0

    animationScript = glue::glue(
        'function animate_<id>(){
        <id>.rotate.x += <rotate["x"]>;
        <id>.rotate.y += <rotate["y"]>;
        <id>.rotate.z += <rotate["z"]>;
        <parentAttributes$id>.updateRenderGraph();
        requestAnimationFrame( animate_<id> );
        }
        animate_<id>()',
        .open = '<',.close = '>'
    )

    out = htmltools::tagList(rdog,
                             htmltools::tags$script(animationScript))

    newAttributes = c(parentAttributes,
                      animation = 'rotate')
    attributes(out) = newAttributes

    return(out)
}

