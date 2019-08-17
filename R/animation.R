#' No animation
#'
#' Just establishes the animation loop without actually moving anything. This
#' is required if you called \code{\link{illustration}} with dragRotate = TRUE
#'
#' @export
animation_none = function(rdog = NULL,id = NULL, addTo = NULL){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    if(is.character(rdog)){
        illoId = rdog
    } else if('zdog' %in% class(rdog)){
        illoId = rdog$x$illId
    }

    animationScript = glue::glue(
        '
        Rdog_variables.built_in.animation_none("<id>","<addTo>","<illoId>");
        ',.open = '<',.close = '>')


    if(!is.null(rdog)){

        rdog$x$jsCode %<>% paste0('\n',animationScript)
        return(rdog)
    } else {
        animationScript
    }

}


#' @export
animation_rotate = function(rdog = NULL,
                            id = NULL,
                            addTo = NULL,
                            rotate = c(x = 0, y = 0, z = 0)){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)


    coords = c('x','y','z')
    rotate[coords[!coords %in% names(rotate)]] = 0

    animationScript = glue::glue(
        '
        Rdog_variables.built_in.animation_rotate("<id>","<addTo>","<illoId>",<rotate["x"]>,<rotate["y"]>,<rotate["z"]>);
        ',.open = '<',.close = '>')


    if(!is.null(rdog)){

        rdog$x$jsCode %<>% paste0('\n',animationScript)
        return(rdog)
    } else {
        animationScript
    }
}

#' @export
animation_ease_in = function(rdog,
                             id,
                             addTo,
                             framesPerCycle = 150,
                             radiansPerCycle = tau,
                             rotateAxis = 'y',
                             power = 2
                             ){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    animationScript = glue::glue(
        '
        Rdog_variables.built_in.animation_ease_in("<id>","<addTo>","<illoId>",<framesPerCycle>,<radiansPerCycle>,"<rotateAxis>",<power>);
        ',.open = '<',.close = '>')

    if(!is.null(rdog)){
        rdog$x$jsCode %<>% paste0('\n',animationScript)
        return(rdog)
    } else {
        animationScript
    }
}
