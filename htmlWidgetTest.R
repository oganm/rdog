#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rdog)
ui <- fluidPage(
    shiny::sliderInput(min = 0, max = 100, inputId = 'slider',label = '',value = 20),
    rdogOutput('dogy',height = 240,width = 240)
)

server <- function(input, output) {
    output$dogy = renderRdog({
        illustration('illo',dragRotate = TRUE) %>%
            shape_rect(width = 50, height = 50,stroke = input$slider, fill = FALSE,rotate = c(z=tau/8)) %>%
            shape_ellipse(id = 'hede',color = 'red',stroke = input$slider,width = 120,height = 120,fill = FALSE) %>%
            zfont_font(id = 'font') %>%
            zfont_text(zfont = 'font',text = 'Text',fontSize = 50,
                       textAlign = 'center',stroke = 4,translate = c(y = 110)) %>%
            # animation_none()
            animation_rotate(rotate = c(y = .05)) %>%
            rdog_widget()

    })

}

# Run the application
shinyApp(ui = ui, server = server)
