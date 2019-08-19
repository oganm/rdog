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


    if('htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',animationScript)
        return(rdog)
    } else if(is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(animationScript)
        }
        animationScript
    }

}


#' @export
animation_rotate = function(rdog = NULL,
                            id = NULL,
                            addTo = NULL,
                            frames = Inf,
                            rotate = c(x = 0, y = 0, z = 0)){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    if(is.infinite(frames)){
        frames = 'Infinity'
    }

    coords = c('x','y','z')
    rotate[coords[!coords %in% names(rotate)]] = 0

    animationScript = glue::glue(
        '
        Rdog_variables.built_in.animation_rotate("<id>","<addTo>","<illoId>",<frames>,<rotate["x"]>,<rotate["y"]>,<rotate["z"]>);
        ',.open = '<',.close = '>')


    if('htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',animationScript)
        return(rdog)
    } else if(is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(animationScript)
        }
        animationScript
    }
}

#' @export
animation_ease_in = function(rdog,
                             id,
                             addTo,
                             frames = Inf,
                             framesPerCycle = 150,
                             radiansPerCycle = tau,
                             rotateAxis = 'y',
                             power = 2){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    if(is.infinite(frames)){
        frames = 'Infinity'
    }

    animationScript = glue::glue(
        '
        Rdog_variables.built_in.animation_ease_in("<id>","<addTo>","<illoId>",<frames>,<framesPerCycle>,<radiansPerCycle>,"<rotateAxis>",<power>);
        ',.open = '<',.close = '>')

    if('htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',animationScript)
        return(rdog)
    } else if(is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(animationScript)
        }
        return(animationScript)
    }
}
