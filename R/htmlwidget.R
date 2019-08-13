#' @import htmlwidgets
#' @export
rdog_widget <- function(rdog, height = NULL, width = NULL) {

    rdog %>%
        as.character %>%
        stringr::str_extract_all('(?<=<script>)(.|\n)*?(?=</script>)') %>%
        {.[[1]]} %>%
        paste(collapse = '\n') ->jsCode



    rdogAttr = attributes(rdog)

    jsCode = rdogAttr$js

    fonts = rdogAttr[rdogAttr %>% purrr::map_lgl(function(x){
        x['what'] == 'font'
    }) %>% sapply(isTRUE)]


    # pass the data and settings using 'x'
    x <- list(
        rdog = rdog,
        jsCode = jsCode,
        canvasID = rdogAttr$canvasID,
        illId = rdogAttr$id,
        width = rdogAttr$width,
        height = rdogAttr$height,
        background = rdogAttr$background,
        fonts = unname(rdogAttr$fonts)
    )

    # create the widget
    htmlwidgets::createWidget("zdog", x, width = width, height = height, package='rdog')
}


#' @export
rdogOutput <- function(outputId, width = "100%", height = "400px") {
    shinyWidgetOutput(outputId, "zdog", width, height, package = "rdog")
}


#' @export
renderRdog <- function(expr, env = parent.frame(), quoted = FALSE) {
    if (!quoted) { expr <- substitute(expr) } # force quoted
    shinyRenderWidget(expr, rdogOutput, env, quoted = TRUE)
}
