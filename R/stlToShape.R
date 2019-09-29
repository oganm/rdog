#' STL to shape
#'
#' Creates a shape from an ASCII stl
#'
#' @param rdog rdog object to add the shape to. Can be a character if called from a code block in shiny
#' @param id id of the anchor. If NULL, a random id will be assigned
#' @param stl contents of an ascii stl file as a character or path to an stl file
#' @param colorMode How to apply the color gradient. \code{mean} will color each triangle
#' based on the mean of their \code{colorAxis}, \code{extreme} will color each triangle
#' based on the maximum and minimum \code{colorAxis} for the triangle. \code{ordered} will
#' ignore \code{colorAxis} and just colors vertexes in the order they appear. Depending on
#' how the file was constructed, this may or may not create a sensible image.
#' @param colorAxis axis to apply the color gradient
#' @param colorMin Starting color of the color gradient
#' @param colorMax Ending color of the color gradient
#' @param visible Is the object visible
#' @param stroke Stroke to add to the polygons.
#' @inheritParams anchor
#' @export
stl_to_shape = function(
    rdog = NULL,
    id = NULL,
    stl,
    colorAxis = 'z',
    colorMin = '#FFFFFF',
    colorMax = '#000000',
    visible = TRUE,
    colorMode = c('mean','extreme','ordered'),
    objectOffset = c(x = 0, y = 0, z = 0),
    stroke = 1,
    addTo = NULL,
    translate = c(x =0, y=0,z=0),
    rotate = c(x = 0, y = 0, z = 0),
    scale = c(x = 1, y = 1, z = 1)){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    colorMode = match.arg(colorMode)

    assertthat::assert_that(assertthat::is.string(id))
    assertthat::assert_that(assertthat::is.string(colorMax))
    assertthat::assert_that(assertthat::is.string(colorMin))

    if(file.exists(stl)){
        if(is_binary(stl)){
            stl = binary_to_ascii_stl(stl)
        } else{
            stl = readLines(stl) %>% paste0(collapse = '\n')
        }
    }

    colorMin = col_to_hex(colorMin)
    colorMax = col_to_hex(colorMax)

    objectOffset = process_coord_vector(objectOffset)

    anchorString = internal_anchor(addTo,
                                   translate,
                                   rotate,
                                   scale)


    group = glue::glue(
        '<id> = new Zdog.Group({
            <anchorString>,
            visible: <tolower(visible)>,
            updateSort: true
        });
        <id>.id = "<id>"',
        .close = '>',.open = '<'
    )



    fullString = glue::glue(
        '
        <group>

        Rdog_variables.utils.parseSTL(`<stl>`,<id>,"<colorAxis>","<colorMin>","<colorMax>", <stroke>,"<colorMode>",<objectOffset>)
        ',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'stl')

}

