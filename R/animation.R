#' No animation
#'
#' Just establishes the animation loop without actually moving anything. This
#' is required if you called \code{\link{illustration}} with dragRotate = TRUE
#'
#' @export
animation_none = function(rdog = NULL,id = NULL, addTo = NULL){

    parentAttributes = attributes(rdog)

    if(is.null(addTo) && !is.null(rdog)){
        addTo = parentAttributes$id
    } else if(is.null(addTo) && is.null(rdog)){
        stop('Both addTo and rdog is left blank')
    }

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    animationScript = glue::glue(
        '
        Rdog_variables.animFuns.animate_<id> = function(){

        <parentAttributes$id>.updateRenderGraph();
        requestAnimationFrame( Rdog_variables.animFuns.animate_<id> );
        }
        Rdog_variables.animFuns.animate_<id>()',
        .open = '<',.close = '>'
    )

    out = htmltools::tagList(rdog,
                             htmltools::tags$script(animationScript))

    parentAttributes$js = paste0(parentAttributes$js,'\n',animationScript)


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
                            id = NULL,
                            addTo = NULL,
                            rotate = c(x = 0, y = 0, z = 0)){

    parentAttributes = attributes(rdog)

    if(is.null(addTo) && !is.null(rdog)){
        addTo = parentAttributes$id
    } else if(is.null(addTo) && is.null(rdog)){
        stop('Both addTo and rdog is left blank')
    }

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    coords = c('x','y','z')
    rotate[coords[!coords %in% names(rotate)]] = 0

    animationScript = glue::glue(
        '
        if(Rdog_variables.animations.animate_<id> == undefined){
            Rdog_variables.animations.animate_<id> = 1
        } else{
           Rdog_variables.animations.animate_<id> += 1
        }


        Rdog_variables.animFuns.animate_<id> = function(){

        if(Rdog_variables.animations.animate_<id> > 1){
            console.log("stopping <id> animation"
            )
            Rdog_variables.animations.animate_<id> -=1
            return;
        }


        <addTo>.rotate.x += <rotate["x"]>;
        <addTo>.rotate.y += <rotate["y"]>;
        <addTo>.rotate.z += <rotate["z"]>;
        <parentAttributes$id>.updateRenderGraph();
        requestAnimationFrame( Rdog_variables.animFuns.animate_<id> );
        }
        Rdog_variables.animFuns.animate_<id>()',
        .open = '<',.close = '>'
    )

    out = htmltools::tagList(rdog,
                             htmltools::tags$script(htmltools::HTML(animationScript)))

    parentAttributes$js = paste0(parentAttributes$js,'\n',animationScript)


    newAttributes = c(parentAttributes,
                      animation = 'rotate')
    attributes(out) = newAttributes

    return(out)
}

