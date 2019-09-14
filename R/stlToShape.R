#' STL to shape
#'
#' Creates a shape from an ASCII stl
#'
#' @param rdog rdog object to add the shape to. Can be a character if called from a code block in shiny
#' @param id id of the anchor. If NULL, a random id will be assigned
#' @param stl contents of an ascii stl file as a character
#' @param colorAxis axis to apply the color gradient
#' @param colorMin Starting color of the color gradient
#' @param colorMax Ending color of the color gradient
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
    stroke = 1,
    addTo = NULL,
    translate = c(x =0, y=0,z=0),
    rotate = c(x = 0, y = 0, z = 0),
    scale = c(x = 1, y = 1, z = 1)){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))
    assertthat::assert_that(assertthat::is.string(stl))


    anchorString = internal_anchor(addTo,
                                   translate,
                                   rotate,
                                   scale)


    anchor = glue::glue(
        '<id> = new Zdog.Anchor({
            <anchorString>
        });',
        .close = '>',.open = '<'
    )



    fullString = glue::glue(
        '
        <anchor>

        Rdog_variables.utils.parseSTL(`<stl>`,<id>,"<colorAxis>","<colorMin>","<colorMax>", <stroke>)
        ',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'anchor')



}
