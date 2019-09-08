#' No animation
#'
#' Just establishes the animation loop without actually moving anything. This
#' is required if you called \code{\link{illustration}} with dragRotate = TRUE
#'
#' @param rdog rdog object to add the animation to. Can be a character if called from a code block in shiny
#' @param id Id of the animation. You should set this if you want to be able
#' to check if this animation is running when getting inputs in a shiny app
#' @param addTo Which element should this animation be added to. No effect on \code{animation_none} and can be ignored.
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

#' Basic rotation
#'
#' Rotates the object at a given speed.
#'
#' @param rdog rdog object to add the animation to. Can be a character if called from a code block in shiny
#' @param id Id of the animation. You should set this if you want to be able
#' to check if this animation is running when getting inputs in a shiny app
#' @param addTo Which element should this animation be added to. If NULL, animation
#' will be set to the entire illustration.
#' @param frames How many frames should the animation run for. Usefult for animations triggered in shiny applications
#' @param rotate Rate of rotation per frame in radians.
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

#' Eased in rotation
#'
#' Rotates the object smoothly
#'
#'
#' @param rdog rdog object to add the animation to. Can be a character if called from a code block in shiny
#' @param id Id of the animation. You should set this if you want to be able
#' to check if this animation is running when getting inputs in a shiny app
#' @param addTo Which element should this animation be added to. If NULL, animation
#' will be set to the entire illustration.
#' @param frames How many frames should the animation run for. Usefult for animations triggered in shiny applications
#' @param framesPerCycle How many frames should a single eased in cycle take
#' @param radiansPerCycle How many radians should the object rotate per cycle. By default a single cycle will
#' cause a full rotation.
#' @param rotateAxis Axis of rotation
#' @param power Exponential power of the easing curve.
#' @export
animation_ease_in = function(rdog,
                             id = NULL,
                             addTo = NULL,
                             frames = Inf,
                             framesPerCycle = 150,
                             pause = 0,
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
        Rdog_variables.built_in.animation_ease_in("<id>","<addTo>","<illoId>",<frames>,<framesPerCycle>,<pause>,<radiansPerCycle>,"<rotateAxis>",<power>);
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
