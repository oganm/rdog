#' Create a zfont
#'
#' Create a zfont that can be used to add text to an illustration
#'
#' @param rdog rdog object to add the font to.
#' @param id id of the font
#' @param font file path to the ttf file that will be used
#' @export
zfont_font = function(rdog = NULL,
                      id,
                      font = system.file('fonts/Roboto-Regular.ttf',package = 'rdog')){

    fontPath = dirname(font)
    fontName = basename(font)

    fullString = glue::glue(
        'Rdog_variables.fonts.<id> = new Zdog.Font({
            src: document.getElementById("<id>-attachment").href
        })',
        .close = '>',.open = '<'
    )


    rdog$x$fonts %<>% c(
        list(list(
            id = id,
            font = paste0('data:application/x-font-truetype;base64,',base64enc::base64encode(font))
        ))
    )

    rdog$x$jsCode %<>% paste0('\n',fullString)


    return(rdog)
}


#' Add text to illustration
#'
#' Use a zfont to add text to an illustration
#'
#' @param rdog rdog object to add the text to. Can be a character if called from a code block in shiny
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param zfont id of the zfont to be used
#' @param fontSize font size of the text. Measured in pixels
#' @param textAlign  Horizontal text alignment, equivalent to the CSS text-align property. This can be either 'left', 'center' or 'right'
#' @param textBaseline Vertical text alignment, equivalent to the HTML5 canvas' textBaseline property. This can be either 'top', 'middle' or 'bottom'
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
zfont_text = function(rdog = NULL,
                      id = NULL,
                      zfont,
                      text,
                      fontSize,
                      textAlign = 'left',
                      textBaseline = 'bottom',
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

    assertthat::assert_that(assertthat::is.string(zfont))
    assertthat::assert_that(assertthat::is.string(text))
    assertthat::assert_that(assertthat::is.number(fontSize))

    selfString = glue::glue(
        'value: "<text>",
        font: Rdog_variables.fonts.<zfont>,
        fontSize: <fontSize>,
        textAlign: "<textAlign>",
        textBaseline: "<textBaseline>"',
        .close = '>',.open = '<'
    )

    fullString = glue::glue(
        'Rdog_variables.fonts.<id> = new Zdog.Text({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'text')


}
