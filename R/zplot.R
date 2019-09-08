#' #' @export
#' plot.zdog = function(x,y,z = NULL,
#'                      color = NULL,
#'                      split = NULL,
#'                      size = 15,
#'                      xlabel = 'x',
#'                      ylabel = 'y',
#'                      rotate.x= 0,
#'                      rotate.y = 0,
#'                      id = NULL,
#'                      class = NULL,
#'                      margin = 20,
#'                      width = 250 ,
#'                      height = 250,
#'                      background = '#FDB',
#'                      linecolor = '#636'){
#'
#'     assertthat::are_equal(length(x),length(y))
#'
#'     if(is.null(id)){
#'         id = 'zdogCanvas'
#'     }
#'     if(is.null(class)){
#'         class = id
#'     }
#'
#'     if(is.null(color)){
#'         color = rep('orange',length(x))
#'     } else if (length(color)>1){
#'         assertthat::are_equal(length(x),length(color))
#'     } else if(length(color)==1){
#'         color = rep(color,length(x))
#'     }
#'
#'     if(is.null(size)){
#'         color = rep(15,length(x))
#'     } else if (length(size)>1){
#'         assertthat::are_equal(length(x),length(size))
#'     } else if(length(size)==1){
#'         size = rep(size,length(x))
#'     }
#'
#'     if(is.null(z)){
#'         z = rep(0,length(x))
#'     }
#'
#'     xBorder = width/2-margin
#'     yBorder = height/2-margin
#'
#'
#'     script = glue::glue(
#'         "
#'         Zfont.init(Zdog)
#'         let <id> = new Zdog.Illustration({
#'             element: '#<id>',
#'              dragRotate: true
#'         });",
#'         .open = '<',.close = '>')
#'
#'     out = htmltools::tagList(
#'         htmltools::htmlDependency(
#'             'zdog',
#'             src = system.file('zdog',package = 'rdog'),
#'             version = '1.0',
#'             script = c('zdog.min.js','zfont.min.js')
#'         ),
#'         htmltools::tags$canvas(id = id,
#'                                class = class,
#'                                width=width,
#'                                height = height,
#'                                style = glue::glue("background:{background}")),
#'         htmltools::tags$script(script),
#'         htmltools::tags$script(glue::glue("
#'                                new Zdog.Shape({
#'                                addTo: <id>,
#'                                closed: false,
#'                                stroke: 10,
#'                                color: '<linecolor>',
#'                                path:[
#'                                { x: -<xBorder>, y: -<yBorder> },
#'                                { x: -<xBorder>, y: +<yBorder> }
#'                                ]
#'                                });",.open = '<',.close = '>')),
#'         htmltools::tags$script(glue::glue("
#'                                new Zdog.Shape({
#'                                addTo: <id>,
#'                                closed: false,
#'                                stroke: 10,
#'                                color: '<linecolor>',
#'                                path:[
#'                                { x: -<xBorder>, y: +<yBorder> },
#'                                { x: <xBorder>, y : +<yBorder> }
#'                                ]
#'                                });",.open = '<',.close = '>')),
#'         htmltools::tags$script(glue::glue('
#'                                           function animate(){
#'                                             <id>.rotate.x += <rotate.x>;
#'                                             <id>.rotate.y += <rotate.y>
#'                                             <id>.updateRenderGraph();
#'                                             requestAnimationFrame( animate );
#'                                           };
#'                                           animate();',.open = '<',.close = '>'))
#'         )
#'
#'     xTrans = ogbox::scaleToInt(as.numeric(x),min = -xBorder+margin,max = +xBorder-margin)
#'     yTrans = ogbox::scaleToInt(as.numeric(y), min = yBorder - margin,max = -yBorder+margin)
#'
#'     for(i in seq_along(x)){
#'
#'         out = c(out,
#'                 htmltools::tagList(
#'                     htmltools::tags$script(glue::glue("
#'                                new Zdog.Shape({
#'                                addTo: <id>,
#'                                closed: false,
#'                                stroke: <size[i]>,
#'                                color: '<color[i]>',
#'                                translate:{x: <xTrans[i]>, y: <yTrans[i]>, z: <z[i]>},
#'                                });",.open = '<',.close = '>'))))
#'     }
#'
#'     out = htmltools::tagList(out)
#'
#'
#'     class(out) = append('rdogPlot',class(out))
#'     return(out)
#' }
#'
#' print.rdogPlot = function(x, ...){
#'     htmltools::html_print(x,...)
#' }

