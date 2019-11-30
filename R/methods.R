#' Update a property of an illustration element
#'
#' @param rdog rdog object where the element is in. Can be a character if called from a code block in shiny
#' @param elementId id of the element to be modified
#' @param ... Properties to be modified.
#'
#' @export
update_property = function(rdog = NULL, elementId,...){

    changedParams = list(...)


    inputs = seq_along(changedParams) %>%
        lapply(function(i){
            process_all_input_types(inputName = names(changedParams)[i],
                                    input = changedParams[[i]])
        })
    names(inputs) = names(changedParams)

    commandString = seq_along(inputs) %>% lapply(function(i){
        glue::glue('{elementId}.{names(inputs)[i]}= {inputs[i]}')
    }) %>% paste(collapse = '\n')

    commandString = glue::glue(
        '
        console.log("updating element")
        console.log("<elementId>" in window)
        console.log("<commandString>")
        if ("<elementId>" in window){
        <commandString>
        <elementId>.updatePath()
        }
        ', .open = '<', .close = '>')

    if(!is.null(rdog) && 'htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',commandString)
        return(rdog)

    } else if(is.null(rdog) || is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(commandString)
            if(is.character('rdog')){
                shinyjs::runjs(glue::glue("{rdog}.updateRenderGraph()"))
            }
        }
        return(commandString)
    }

}


#' Copy an object
#'
#' @param rdog rdog object where the element is in. Can be a character if called from a code block in shiny
#' @param id id of the element to be created
#' @param what id of the element to be copied
#' @param ... Properties to be modified.
#'
#' @export
copy = function(rdog = NULL, id = NULL, what, ...){
    changedParams = list(...)

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }


    inputs = seq_along(changedParams) %>%
        lapply(function(i){
            process_all_input_types(inputName = names(changedParams)[i],
                                    input = changedParams[[i]])
        })
    names(inputs) = names(changedParams)

    assertthat::assert_that(assertthat::is.string(what))

    inputString = seq_along(inputs) %>% lapply(function(i){
        glue::glue('{names(inputs)[i]}: {inputs[i]}')
    }) %>% paste(collapse = ',\n')

    commandString = glue::glue(
        "
        <id> = <what>.copy({
            <inputString>
        })
        ",
    .open = '<',.close = '>')


    if(!is.null(rdog) && 'htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',commandString)
        rdog$x$components %<>% c(
            list(copy =
                     list(what = 'copy',
                          id = id))
        )
        return(rdog)

    } else if(is.null(rdog) || is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(commandString)
            if(is.character('rdog')){
                shinyjs::runjs(glue::glue("{rdog}.updateRenderGraph()"))
            }
        }
        return(commandString)
    }

}

#' Copy an object and its children
#'
#' @param rdog rdog object where the element is in. Can be a character if called from a code block in shiny
#' @param id id of the element to be created
#' @param what id of the element to be copied
#' @param ... Properties to be modified.
#'
#' @export
copy_graph = function(rdog = NULL, id, what, ...){
    changedParams = list(...)

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }


    inputs = seq_along(changedParams) %>%
        lapply(function(i){
            process_all_input_types(inputName = names(changedParams)[i],
                                    input = changedParams[[i]])
        })
    names(inputs) = names(changedParams)

    assertthat::assert_that(assertthat::is.string(what))

    inputString = seq_along(inputs) %>% lapply(function(i){
        glue::glue('{names(inputs)[i]}: {inputs[i]}')
    }) %>% paste(collapse = ',\n')

    commandString = glue::glue(
        "
        <id> = <what>.copyGraph({
            <inputString>
        })
        ",
        .open = '<',.close = '>')


    if(!is.null(rdog) && 'htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',commandString)
        rdog$x$components %<>% c(
            list(copy =
                     list(what = 'copy',
                          id = id))
        )
        return(rdog)

    } else if(is.null(rdog) || is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(commandString)
            if(is.character('rdog')){
                shinyjs::runjs(glue::glue("{rdog}.updateRenderGraph()"))
            }
        }
        return(commandString)
    }

}


#' Add child item
#' @export
add_child = function(rdog = NULL, to, what){
    assertthat::assert_that(assertthat::is.string(what))
    assertthat::assert_that(assertthat::is.string(to))


    commandString = glue::glue(
        "
        <to>.addChild(<what>);
        ",
        .open = '<',.close = '>')

    if(!is.null(rdog) && 'htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',commandString)
        return(rdog)

    } else if(is.null(rdog) || is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(commandString)
            if(is.character('rdog')){
                shinyjs::runjs(glue::glue("{rdog}.updateRenderGraph()"))
            }
        }
        return(commandString)
    }

}


#' Remove child item
#' @export
remove_child = function(rdog = NULL, from, what){
    assertthat::assert_that(assertthat::is.string(what))
    assertthat::assert_that(assertthat::is.string(from))



    commandString = glue::glue(
        "
        <from>.removeChild(<what>);
        ",
        .open = '<',.close = '>')

    if(!is.null(rdog) && 'htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',commandString)
        return(rdog)

    } else if(is.null(rdog) || is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(commandString)
            if(is.character('rdog')){
                shinyjs::runjs(glue::glue("{rdog}.updateRenderGraph()"))
            }
        }
        return(commandString)
    }
}


#' Remove element from parent
#' @export
remove = function(rdog = NULL, what){
    assertthat::assert_that(assertthat::is.string(what))


    commandString = glue::glue(
        "
        <what>.remove();
        ",
        .open = '<',.close = '>')

    if(!is.null(rdog) && 'htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',commandString)
        return(rdog)

    } else if(is.null(rdog) || is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(commandString)
            if(is.character('rdog')){
                shinyjs::runjs(glue::glue("{rdog}.updateRenderGraph()"))
            }
        }
        return(commandString)
    }
}
