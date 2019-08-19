
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
