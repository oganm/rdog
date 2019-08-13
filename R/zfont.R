
zfont_font = function(rdog = NULL,
                      id,
                      font = system.file('fonts/Roboto-Regular.ttf',package = 'rdog')){

    fontPath = dirname(font)
    fontName = basename(font)

    parentAttributes = attributes(rdog)

    fullString = glue::glue(
        'Rdog_variables.fonts.<id> = new Zdog.Font({
            src: document.getElementById("<id>-attachment").href
        })',
        .close = '>',.open = '<'
    )

    parentAttributes = attributes(rdog)

    out = htmltools::tagList(rdog,
                             htmltools::tags$link(href =
                                                      paste0('data:application/x-font-truetype;base64,',base64enc::base64encode(font)),
                                                  id = glue::glue('{id}-attachment'),
                                                  rel = 'attachment'),
                             # htmltools::htmlDependency(name = id,version = '1.0',src = fontPath,attachment = fontName),
                             htmltools::tags$script(fullString))

    fontList = list(list(
        id = id,
        font = paste0('data:application/x-font-truetype;base64,',base64enc::base64encode(font))
    ))
    names(fontList) = id

    parentAttributes$js = paste0(parentAttributes$js,'\n',fullString)


    parentAttributes$fonts = c(parentAttributes$fonts,
                               fontList)

    # newAttributes = c(parentAttributes,
    #                   list(font = list(
    #                       what = 'font',
    #                       id = id,
    #                       font = paste0('data:application/x-font-truetype;base64,',base64enc::base64encode(font))
    #                   )))

    attributes(out) = parentAttributes
    return(out)
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


    # if a parent isn't specified, add to the illustration
    if(is.null(addTo) && !is.null(rdog)){
        addTo = attributes(rdog)$id
    } else if(is.null(addTo) && is.null(rdog)){
        stop('Both addTo and rdog is left blank')
    }

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
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

    parentAttributes = attributes(rdog)
    out = htmltools::tagList(rdog,
                             htmltools::tags$script(fullString))

    parentAttributes$js = paste0(parentAttributes$js,'\n',fullString)

    newAttributes = c(parentAttributes,
                      list(text = list(
                          what = 'text',
                          id = id,
                          parent = addTo
                      )))

    attributes(out) = newAttributes
    return(out)

}
