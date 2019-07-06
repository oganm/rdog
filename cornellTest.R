id = 'cornell'
width = 240
height = 240
background = '#FDB'
class = id

script = glue::glue(
    "
        let <id> = new Zdog.Illustration({
            element: '#<id>',
            rotate:{x: -Zdog.TAU/20},
             dragRotate: true
        });",
    .open = '<',.close = '>')

out = htmltools::tagList(
    htmltools::htmlDependency(
        'zdog',
        src = system.file('zdog',package = 'rdog'),
        version = '1.0',
        script = c('zdog.min.js','zfont.min.js')
    ),
    htmltools::tags$canvas(id = id,
                           class = class,
                           width=width,
                           height = height,
                           style = glue::glue("background:{background}")),
    htmltools::tags$script(script),
    htmltools::tags$script(glue::glue("
                           let box = new Zdog.Box({
                           addTo: <id>,
                           width: 160,
                           height: 160,
                           depth: 160,
                           stroke: 1,
                           color: '#C25', // default face color
                           leftFace: 'red',
                           rightFace: 'green',
                           topFace: 'white',
                           bottomFace: 'white',
                           frontFace: false,
                           rearFace: 'lightgray',
                           });",.open = '<',.close = '>')),
    # htmltools::tags$script(glue::glue("new Zdog.Shape({
    #                                     addTo: <id>,
    #                                     stroke: 60,
    #                                     color: '#636',
    #                                     translate: {y: 50,z: 0, x: 40}
    #                                   });",.open = '<',.close = '>')),
    htmltools::tags$script(glue::glue('
                                          let ticker = 0;
                                          let cycleCount = 150;
                                          let timesForCycle = 2;

                                          function animate(){
                                            let progress = ticker/cycleCount;
                                            let tween = Zdog.easeInOut( progress % 1, 3 );
                                            let timesTurned = Math.floor(progress) % timesForCycle
                                            let preRot = Zdog.TAU/timesForCycle * timesTurned
                                            <id>.rotate.y = tween * Zdog.TAU/timesForCycle + preRot +Zdog.TAU/16;
                                            ticker++;
                                            <id>.updateRenderGraph();
                                            requestAnimationFrame( animate );
                                          };
                                          animate();',.open = '<',.close = '>')) ,
    htmltools::tags$script("let donut = new Zdog.Ellipse({
  addTo: cornell,
  diameter: 80,
  stroke: 20,
  color: '#636',
});")
)


htmltools::html_print(out)

