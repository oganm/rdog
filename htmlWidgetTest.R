#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
devtools::load_all()
ui <- fluidPage(
    shinyjs::useShinyjs(),
    shiny::actionButton(inputId = 'anim',label = 'Animate'),
    shiny::sliderInput(min = 0, max = 140, inputId = 'slider',label = '',value = 80),
    rdogOutput('dogy',height = 240,width = 240)
)

server <- function(input, output) {
    output$dogy = renderRdog({
        illustration('illo',width = 250,height = 250,dragRotate = TRUE) %>%
            shape_box(id ='cornell',
                      width = 150,
                      height = 150,
                      depth = 150,
                      translate = c(y = '-20'),
                      rotate = c(x = -tau/20,y = tau/16),
                      stroke = 1,
                      color = '#C25',
                      leftFace = 'red',
                      rightFace =  'green',
                      topFace =  'white',
                      bottomFace =  'white',
                      frontFace =  FALSE,
                      rearFace= 'lightgray') %>%
            shape_ellipse(
                addTo = 'cornell',
                id = "ellipse",
                diameter = input$slider,
                stroke = 20,
                color = '#636',fill = FALSE
            ) %>%
            zfont_font(id = 'font') %>%
            zfont_text(zfont = 'font', text = 'Cornell Box',fontSize = 24,translate = c(y = 120),textAlign = 'center')  %>%
            animation_none(id = 'none')
            # animation_rotate(addTo = 'ellipse',id = 'rotate',rotate = c(y = 0.05)) %>%
            # animation_ease_in(id = 'ease',frames = Inf,radiansPerCycle = tau/2,addTo='cornell',framesPerCycle = 120,power = 3)
    })

    observe({
        print(input$anim)
        if(input$anim>0){
            animation_ease_in(id = 'ease',rdog = 'illo',frames = 120,radiansPerCycle = tau/2,addTo='cornell',framesPerCycle = 120,power = 3)
            # animation_rotate(id = 'rotate', rdog = 'illo',frames = 120, rotate = c(y = tau/120))
        }
    })

}

shinyApp(ui = ui, server = server)
