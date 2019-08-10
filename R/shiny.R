make_shiny = function(rdog){
    rdog %>%
        as.character %>%
        stringr::str_extract_all('(?<=<script>)(.|\n)*?(?=</script>)') %>%
        {.[[1]]} %>%
        paste(collapse = '\n') ->jsCode


    # fixerCode =
    #     glue::glue(
    #         "let canvas = document.getElementById('<attributes(rdog)$id>')
    #         let parent = canvas.parentNode
    #         parent.removeChild(canvas)
    #         parent.appendChild(canvas)
    #         ",
    #         .open = '<',.close = '>')

    shinyjs::runjs(paste0('\n',jsCode))

    out = htmltools::tagList(rdog,
                             htmltools::tags$script(jsCode))
    return(out)

}


rdogOutput = function(id,
                      class = id,
                      height = 240,
                      width = 240,
                      background = '#FFDDBB'){


    dependency = htmltools::htmlDependency(
        'zdog',
        src = system.file('zdog',package = 'rdog'),
        version = '1.0',
        script = c('zdog.min.js','zfont.min.js')
    )

    canvas = htmltools::tags$canvas(id = id, class = class,width=width, height = height, style = glue::glue("background:{background}"))

    tagList(shinyjs::useShinyjs(),
            dependency,
            canvas)

}
