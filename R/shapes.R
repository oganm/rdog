#' Ellipse
#'
#' Add an elipse to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param diameter Diameter of the circle
#' @param width,height Width and height of the ellipse. Overrides diameter
#' @param quarters How many quarters should be drawn. 4 draws a whole circle, 2
#' is a semi circle etc.
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_ellipse = function(rdog = NULL,
                         id = NULL,
                         diameter = 1,
                         width = diameter,
                         height = diameter,
                         quarters = 4,
                         color = '#333',
                         stroke = 1,
                         fill = TRUE,
                         closed = TRUE,
                         visible = TRUE,
                         backface = TRUE,
                         front = c(z = 1),
                         addTo = NULL,
                         translate = c(x =0, y=0,z=0),
                         rotate = c(x = 0, y = 0, z = 0),
                         scale = c(x = 1, y = 1, z = 1)
){
    # if a parent isn't specified, add to the illustration
    if(is.null(addTo) && !is.null(rdog)){
        addTo = attributes(rdog)$id
    } else if(is.null(addTo) && is.null(rdog)){
        stop('Both addTo and rdog is left blank')
    }

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    assertthat::assert_that(assertthat::is.string(id))


    anchorString = internal_anchor(addTo,
                                   translate,
                                   rotate,
                                   scale)

    shapeString = internal_shape(color,
                                 stroke,
                                 fill,
                                 closed,
                                 visible,
                                 backface,
                                 front)

    assertthat::assert_that(assertthat::is.number(width))
    assertthat::assert_that(assertthat::is.number(height))
    assertthat::assert_that(assertthat::is.number(diameter))
    assertthat::assert_that(assertthat::is.number(quarters))


    selfString = glue::glue(
        'width: <width>,
        height: <height>,
        quarters: <quarters>',
        .close = '>',.open = '<'
    )


    fullString = glue::glue(
        '<id> = new Zdog.Ellipse({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    if(!is.null(rdog)){
        parentAttributes = attributes(rdog)

        out = htmltools::tagList(rdog,
                                 htmltools::tags$script(fullString))

        parentAttributes$js = paste0(parentAttributes$js,'\n',fullString)


        newAttributes = c(parentAttributes,
                          list(ellipse = list(
                              what = 'ellipse',
                              id = id,
                              parent = addTo
                          )))

        attributes(out) = newAttributes
        return(out)
    } else {
        fullString
    }


}


#' Rectangle
#'
#' Add a rectangle to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param width,height Width and height of the rectangle.
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_rect = function(
    rdog = NULL,
    id = NULL,
    width = 1,
    height = 1,
    color = '#333',
    stroke = 1,
    fill = TRUE,
    closed = TRUE,
    visible = TRUE,
    backface = TRUE,
    front = c(z = 1),
    addTo = NULL,
    translate = c(x =0, y=0,z=0),
    rotate = c(x = 0, y = 0, z = 0),
    scale = c(x = 1, y = 1, z = 1)){

    # if a parent isn't specified, add to the illustration
    if(is.null(addTo) && !is.null(rdog)){
        addTo = attributes(rdog)$id
    } else if(is.null(addTo) && is.null(rdog)){
        stop('Both addTo and rdog is left blank')
    }

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    assertthat::assert_that(assertthat::is.string(id))

    anchorString = internal_anchor(addTo,
                                   translate,
                                   rotate,
                                   scale)

    shapeString = internal_shape(color,
                                 stroke,
                                 fill,
                                 closed,
                                 visible,
                                 backface,
                                 front)

    assertthat::assert_that(assertthat::is.number(width))
    assertthat::assert_that(assertthat::is.number(height))

    selfString = glue::glue(
        'width: <width>,
        height: <height>',
        .close = '>',.open = '<'
    )

    fullString = glue::glue(
        '<id> = new Zdog.Rect({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )



    if(!is.null(rdog)){
    parentAttributes = attributes(rdog)

    out = htmltools::tagList(rdog,
                             htmltools::tags$script(fullString))


    parentAttributes$js = paste0(parentAttributes$js,'\n',fullString)

    newAttributes = c(parentAttributes,
                      list(rect = list(
                          what = 'rect',
                          id = id,
                          parent = addTo
                      )))

    attributes(out) = newAttributes
    return(out)
    } else{
        fullString
    }
}
