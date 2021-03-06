
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
#' @param front Determine where the front of the shape is to decide rendering backface color.
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
        'color: "<col_to_hex(color)>",
        stroke: <stroke>,
        fill: <tolower(fill)>,
        closed: <tolower(closed)>,
        visible: <tolower(visible)>,
        backface: <if(is.logical(backface)){tolower(backface)}else{paste0("\'",col_to_hex(backface),"\'")}>,
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

    assertthat::assert_that(assertthat::is.string(addTo))

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
    if(is.null(addTo) && !is.null(rdog) && !is.character(rdog)){
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


process_shape_output = function(rdog, id, addTo, script, what){

    if(!is.null(rdog) && 'htmlwidget' %in% class(rdog)){
        rdog$x$jsCode %<>% paste0('\n',script)
        rdog$x$components %<>% c(
            list(ellipse =
                     list(what = what,
                          id = id,
                          parent = addTo))
        )
        return(rdog)

    } else if(is.null(rdog) || is.character(rdog)){
        if(shiny::isRunning()){
            shinyjs::runjs(script)
        }
        return(script)
    }
}


process_path = function(path){
    assertthat::assert_that(is.list(path))

    seq_along(path) %>% sapply(function(i){
        if(is.null(names(path)[i]) || names(path)[i] == ''){
            assertthat::assert_that(!is.list(path[[i]]),msg = 'Nested elements in path must have names')
            return(process_coord_vector(path[[i]]))
        } else{
            if(is.list(path[[i]])){
                return(
                    glue::glue('{ !names(path)[i]@: [\n!path[[i]] %>% lapply(process_coord_vector) %>% c(list(sep=",\n")) %>% do.call(paste,.)@\n]}',.close = '@',.open = '!')
                )
            } else{
                return(
                    glue::glue('{ <names(path)[i]>: <process_coord_vector(path[[i]])> }',.open = '<',.close = '>')
                )
            }
        }
    }) %>% c(list(sep = ',\n')) %>% do.call(paste,.) -> pathString

    paste0('[',pathString,']')
}

process_all_input_types = function(inputName, input){
    out = switch(inputName,
           color = {
               assertthat::assert_that(assertthat::is.string(input))
               glue::glue('"{col_to_hex(input)}"')
           },
           stroke = {
               assertthat::assert_that(assertthat::is.number(input))
               input
           },
           fill = {
               assertthat::assert_that(is.logical(input))
               tolower(input)
           },
           closed = {
               assertthat::assert_that(is.logical(input))
               tolower(input)
           },
           visible = {
               assertthat::assert_that(is.logical(input))
               tolower(input)
           },
           backface = {
               assertthat::assert_that(is.logical(input) | assertthat::is.string(input))
               if(is.logical(input)){tolower(input)}else{paste0("\'",col_to_hex(input),"\'")}
           },
           front = {
               process_coord_vector(input)
           },
           addTo = {
               assertthat::assert_that(assertthat::is.string(input))
               input
           },
           translate = {
               process_coord_vector(input)
           },
           rotate = {
               process_coord_vector(input)
           },
           scale = {
               process_coord_vector(input,allowSingle=TRUE,default=1)
           },
           height = {
               assertthat::assert_that(assertthat::is.number(input))
               input
           },
           width = {
               assertthat::assert_that(assertthat::is.number(input))
               input
           },
           diameter = {
               assertthat::assert_that(assertthat::is.number(input))
               input
           },
           quarters = {
               assertthat::assert_that(assertthat::is.number(input))
               input
           },
           cornerRadius = {
               assertthat::assert_that(assertthat::is.number(input))
               input
           },
           radius = {
               assertthat::assert_that(assertthat::is.number(input))
               input
           },
           sides = {
               assertthat::assert_that(input%%1 == 0)
               input
           },
           path = {
               process_path(input)
           },
           length = {
               assertthat::assert_that(assertthat::is.number(input))
               input
           },
           depth = {
               assertthat::assert_that(assertthat::is.number(input))

           },
           frontFace = {
               assertthat::assert_that(is.logical(input) | assertthat::is.string(input))
               if(is.logical(frontFace)){tolower(input)}else{paste0("\'",col_to_hex(input),"\'")}
           },
           rearFace = {
               assertthat::assert_that(is.logical(input) | assertthat::is.string(input))
               if(is.logical(frontFace)){tolower(input)}else{paste0("\'",col_to_hex(input),"\'")}
           },
           leftFace = {
               assertthat::assert_that(is.logical(input) | assertthat::is.string(input))
               if(is.logical(frontFace)){tolower(input)}else{paste0("\'",col_to_hex(input),"\'")}
           },
           rightFace = {
               assertthat::assert_that(is.logical(input) | assertthat::is.string(input))
               if(is.logical(frontFace)){tolower(input)}else{paste0("\'",col_to_hex(input),"\'")}
           },
           topFace = {
               assertthat::assert_that(is.logical(input) | assertthat::is.string(input))
               if(is.logical(frontFace)){tolower(input)}else{paste0("\'",col_to_hex(input),"\'")}
           },
           bottomFace = {
               assertthat::assert_that(is.logical(input) | assertthat::is.string(input))
               if(is.logical(frontFace)){tolower(input)}else{paste0("\'",col_to_hex(input),"\'")}
           },
           updateSort = {
               assertthat::assert_that(is.logical(input))
               tolower(input)
           },
           visible = {
               assertthat::assert_that(is.logical(input))
               tolower(input)
           })

    if(is.null(out)){
        stop('Unkown input type')
    }
    return(out)
}

#' Get boundaries of an stl file
#' @param stl A character with contents of an stl file
#' @export
get_stl_bounds = function(stl){

    if(file.exists(stl)){
        if(is_binary(stl)){
            stl = binary_to_ascii_stl(stl)
        } else{
            stl = readLines(stl) %>% paste0(collapse = '\n')
        }
    }

    stlLines = stl %>% strsplit('\n') %>% {.[[1]]}

    lapply(stlLines, function(x){
        if(grepl('vertex',x)){
            coords = x %>% stringr::str_extract('(?<=vertex ).*') %>% strsplit(' ') %>% {.[[1]]} %>% as.numeric()
            names(coords) = c('x','y','z')
            return(coords)
        } else{
            return(NULL)
        }
    }) %>% {.[!sapply(.,is.null)]} -> coordinates

    xs = coordinates %>% purrr::map_dbl('x')
    ys = coordinates %>% purrr::map_dbl('y')
    zs = coordinates %>% purrr::map_dbl('z')

    list(
        x = c(min(xs),max(xs)),
        y = c(min(ys), max(ys)),
        z = c(min(zs),max(zs))
    )

}

#' Create the transform parameter to center an stl
#'
#' @param stl_bounds output of \code{\link{get_stl_bounds}}
#' @export
center_stl = function(stl_bounds, exclude = NULL){
    stl_bounds %>% sapply(function(x){
        -(min(x) + (max(x) - min(x))/2)
    })->out

    if(!is.null(exclude)){
        out[exclude] = 0
    }
    return(out)
}

#' Convert binary STL to ASCII stl
#'
#' @param file Input filepath
#' @param output output filepath
#' @export
binary_to_ascii_stl = function(file,output = NULL){
    bin = readBin(file, what= 'raw',
                  n = file.info(file)$size)

    if(is.null(output)){
        output = tempfile()
    }
    cat('solid \n',file = output)
    faces = readBin(bin[81:84],what = 'int',size = 4)

    for (i in seq_len(faces)){
        # facet normal
        x = readBin(bin[i*50 + (85:88)],'double',size = 4)
        y = readBin(bin[i*50 + (89:92)],'double',size = 4)
        z = readBin(bin[i*50 + (93:96)],'double',size = 4)

        cat(glue::glue('facet normal {x} {y} {z}\nouter loop\n\n'),file = output, append = TRUE)

        # vertexes
        for (j in 1:3){
            x = readBin(bin[i*50 + 12*j + (85:88)],'double',size = 4)
            y = readBin(bin[i*50 + 12*j + (89:92)],'double',size = 4)
            z = readBin(bin[i*50 + 12*j + (93:96)],'double',size = 4)

            cat(glue::glue('vertex {x} {y} {z}\n\n'),file = output, append = TRUE)
        }

        cat(glue::glue('endloop\nendfacet\n\n'),file = output, append = TRUE)
    }

    readLines(output) %>% paste(collapse = '\n')
}


# https://stackoverflow.com/questions/16350164/native-method-in-r-to-test-if-file-is-ascii
is_binary = function(filepath,max=1000){
    f=file(filepath,"rb",raw=TRUE)
    b=readBin(f,"int",max,size=1,signed=FALSE)
    close(f)
    return(max(b)>128)
}

col_to_hex = function(colname){
    assertthat::assert_that(assertthat::is.string(colname))
    col = tryCatch({
        col =grDevices::col2rgb(colname, alpha = TRUE)
        rgb(red = col['red', ]/255, green = col['green', ]/255, blue = col['blue',]/255, alpha = col['alpha',]/255)

        }, error = function(e){colname})

    return(col)
}
