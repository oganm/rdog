#' @export
shape_ellipse = function(rdog = NULL,
                         id = NULL,
                         diameter = 80,
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

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    assertthat::assert_that(assertthat::is.string(id))

    fullString = glue::glue(
        'let <id> = new Zdog.Ellipse({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    parentAttributes = attributes(rdog)

    out = htmltools::tagList(rdog,
                             htmltools::tags$script(fullString))

    newAttributes = c(parentAttributes,
                      list(ellipse = list(
                          what = 'ellipse',
                          id = id,
                          parent = addTo
                      )))

    attributes(out) = newAttributes
    return(out)

}
