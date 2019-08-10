#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
devtools::load_all('.')
ui <- fluidPage(
    shiny::sliderInput(min = 0, max = 100, inputId = 'slider',label = '',value = 20),

    rdogOutput(id = 'thecanvas',height = 240,width = 240)
)

server <- function(input, output) {
   observe({
        illustration(id = 'canv',canvasID = 'thecanvas',resize = FALSE) %>%
            shape_ellipse(id = 'hede',color = 'red',stroke = input$slider,width = 120,height = 120,fill = FALSE) %>%
            animation_none() %>%
            make_shiny()
    })

    observe({

    })

}

shinyApp(ui = ui, server = server)
