#' Shape from an svg path
#'
#' Create a shape from an svg path
#'
#' @param rdog rdog object to add the shape to. Can be a character if called from a code block in shiny
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param svgPath Path data from svg
#' @param svgWidth,svgHeight Full width and height of the svg path. Used for centering.
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
svg_path_to_shape = function(rdog = NULL,
                       id = NULL,
                       svgPath,
                       svgWidth,
                       svgHeight,
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

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)
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

    svgMoves = svgPath %>%  strsplit('M|m') %>%
        {.[[1]][-1]} %>% paste0('M',.)

    assertthat::assert_that(class(svgPath) == 'character')

    groupSelfString = glue::glue(
        'updateSort: true,
        visible: <tolower(visible)>',
        .close = '>',.open = '<'
    )

    groupString = glue::glue(
        '<id> = new Zdog.Group({
            <groupSelfString>,
            <anchorString>
        });',
        .close = '>',.open = '<'
    )


    shapeAnchor = internal_anchor(id,
                                   translate,
                                   rotate,
                                   scale)


    fullString = glue::glue(
        '
        <groupString>

        svgPaths = Rdog_variables.utils.processSVGData("<svgPath>",<svgWidth>,<svgHeight>)

        for(var svgPath of svgPaths){
            new Zdog.Shape({
                path: svgPath,
                <shapeString>,
                <shapeAnchor>
            })
        }

        ',
        .close = '>',.open = '<'
    )


    process_shape_output(rdog, id, addTo, fullString, 'svg')


}
