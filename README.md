rdog
================

This is a port of the [zdog](https://zzz.dog/) pseudo 3D engine for R.
Currently a work in progres.

## Installation

``` r
devtools::install_github('oganm/rdog')
```

Install the latest Rstudio to make sure it works well with the built in
viewer. Some elements appears to misbehave in older versions.

## Why?

…

## Basic usage

``` r
illustration('illo',dragRotate = TRUE) %>% 
        shape_rect(width = 50, height = 50,stroke = 20, fill = FALSE,rotate = c(z=tau/8)) %>% 
    shape_ellipse(id = 'hede',color = 'red',stroke = 20,width = 120,height = 120,fill = FALSE) %>%
    zfont_font(id = 'font') %>% 
    zfont_text(zfont = 'font',text = 'Text',fontSize = 50,
               textAlign = 'center',stroke = 4,translate = c(y = 110)) %>%
    # animation_none()
    animation_rotate(rotate = c(y = .05)) %>% 
    record_gif(fps = 10, duration = 4,file = 'README_files/rotate.gif')
```

    ## Registered S3 method overwritten by 'shiny':
    ##   method            from   
    ##   print.key_missing fastmap

![](README_files/figure-gfm/basic-1.gif)<!-- -->

![](README_files/rotate.gif)

`record_gif` is not required for interactive usage. By default, the
output is a tagList, that can be automatically displayed in the viewer.
This is not supported on a github readme so rendering into gif is
necesary. `record_gif` function is horribly written and is slow. You’re
better of recording your screen for in most cases

## Use in shiny

WIP. Currently a little broken.

<!--
Currently the shiny syntax is a little non-standard and it's likely to change. As 
shown in the example below, one has to use `rdogOutput` on the UI code like a regular
shiny UI element, however, instead of using a function like `renderRdog`, instead we
create the rdog illusration inside an `observe` code block and pass the output to
`make_shiny`.


```r
library(shiny)
library(rdog)
ui <- fluidPage(
    shiny::sliderInput(min = 0, max = 100, inputId = 'slider',label = '',value = 20),

    rdogOutput(id = 'canv')
)

server <- function(input, output) {
   observe({
        illustration(id = 'canv') %>%
            shape_ellipse(id = 'hede',color = 'red',stroke = input$slider,width = 120,height = 120,fill = FALSE) %>%
            animation_none() %>%
            make_shiny()
    })

}

shinyApp(ui = ui, server = server)

```
-->

## Use as shiny inputs

WIP
