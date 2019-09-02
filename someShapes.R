illustration('illo',width = 250,height = 250,dragRotate = TRUE,background = 'white') %>%
    shape_box(id = 'head', stroke = 30,width = 100,height = 80,depth = 100,
              color = 'bisque') %>%
    shape_shape(addTo = 'head',stroke = 20,translate = c(z = ,y = -20,x = -25)) %>%
    shape_shape(addTo = 'head',stroke = 20,translate = c(z = 70,y = -20,x = +25)) %>%
    animation_none()



illustration('illo',width = 250,height = 250,dragRotate = TRUE,background = 'white',rotate = c(y = tau/8, x = -tau/8)) %>%
    shape_box(id = 'hex',bottomFace = '#EEAA00',
              frontFace =  FALSE,
              topFace = FALSE,
              rightFace= FALSE,
              leftFace = '#EE6622',rearFace = '#ED9965',
              width = 100, height = 100, depth = 100
              ) %>%
    shape_shape(id = 'R',stroke = 10, color = '#663366',fill  = FALSE, closed = FALSE, path = list(c(y=40,x = -25),
                                                           c(y = -30,x = -25),
                                                           arc = list(c(y = -10, x = 50),
                                                                      c(y = 10, x = -25)),
                                                           c(y= 40, x = 25))) %>%
    animation_none()


eyeDistance = 55
eyeHeight = -25
noseHeight = 15
mouthLow = 45
mouthHigh = 15
mouthWidth = 50
illustration('illo',width = 260,height = 260,dragRotate = TRUE) %>%
    # shape_box(id = 'hex',bottomFace = 'green',
    #           frontFace =  FALSE,
    #           topFace = FALSE,
    #           rightFace= FALSE,
    #           leftFace = 'white',rearFace = 'FIREBRICK',
    #           width = 150, height = 150, depth = 150,rotate = c(y = tau/8, x = -tau/8)
    # )  %>%
    shape_ellipse(id = 'leftEye',translate = c(y = eyeHeight,x = -eyeDistance/2),diameter = 10,stroke = 10) %>%
    shape_ellipse(id = 'right',translate = c(y = eyeHeight,x = eyeDistance/2),diameter = 10,stroke = 10) %>%
    shape_ellipse(id = 'nose',translate = c(y = noseHeight),width = 35, height = 25) %>%
    shape_shape(id = 'fulcrum', translate = c(y = noseHeight), stroke = 5, path = list(c(y = 0),c(y = mouthLow-20))) %>%
    shape_shape(id = 'mouth', translate = c(y = noseHeight), stroke = 5,
                path = list(c(x = -mouthWidth/2, y = mouthHigh),
                            arc = list(c(y = mouthLow),
                                       c(y = mouthHigh, x = mouthWidth/2))),closed = FALSE,fill = FALSE) %>%
    shape_polygon(stroke = 5, translate = c(x = -40, y = -60),radius = 15,rotate = c(z = -tau/16)) %>%
    shape_polygon(stroke = 5, translate = c(x = 40, y = -60),radius = 15,rotate = c(z = tau/16)) %>%
    # shape_shape(id = 'letftEar',stroke = 5, closed = FALSE, fill = FALSE,
    #             path = list(c(x = -30, y =-60),
    #                         c(x = -40, y = -70),
    #                         c(x = -70, y = -30),
    #                         c(x = -65, y = -20))) %>%
    # shape_shape(id = 'leftEar',stroke = 5,
    #             path = list(c(x = -30, y = -60),
    #                         arc = list(c(x = -43, y = -55),
    #                                    c(x = -48, y = -50)))) %>%
    # shape_box(id = 'head', stroke = 30,width = 70,height = 45,depth = 45,
    #           color = 'Chocolate') %>%
    zfont_font(id = 'font') %>%
    zfont_text(zfont = 'font',text = 'rdog',fontSize = 35,translate = c(y = 90),textAlign = 'center') %>%
    animation_ease_in(framesPerCycle = 120,pause = 120, power = 30,rotateAxis = 'y') %>% record_gif(file = 'logo.gif', duration = 15)


r = 120
1:6 %>% lapply(function(i){
    x = r * cos(2*pi*i/6)
    y = r * sin(2*pi*i/6)
    return(c(x = x ,y = y))
}) -> polyEdges

illustration('illo',width = 260,height = 260,dragRotate = TRUE) %>%
    # shape_polygon(id = 'hex',sides = 6, stroke = 10,radius = 120,fill = FALSE,color = '#636') %>%
    anchor(id = 'hexAnchor',rotate = c(z=tau/12)) %>%
    shape_shape(id = 'hex1',addTo = 'hexAnchor',stroke = 10,color = '#636',path = polyEdges[1:2]) %>%
    shape_shape(id = 'hex2',addTo = 'hexAnchor',stroke = 10,color = '#636',path = polyEdges[2:3]) %>%
    shape_shape(id = 'hex3',addTo = 'hexAnchor',stroke = 10,color = '#636',path = polyEdges[3:4]) %>%
    shape_shape(id = 'hex3',addTo = 'hexAnchor',stroke = 10,color = '#636',path = polyEdges[4:5]) %>%
    shape_shape(id = 'hex4',addTo = 'hexAnchor',stroke = 10,color = '#636',path = polyEdges[5:6]) %>%
    shape_shape(id = 'hex4',addTo = 'hexAnchor',stroke = 10,color = '#636',path = polyEdges[c(6,1)]) %>%
    anchor(id='dogMainAnchor', translate =  c(y = -10,z = 50)) %>%
    anchor(id = 'dogAnchor',addTo = 'dogMainAnchor',translate = c(x = -10),rotate = c(y = 1*pi/16)) %>%
    # shape_box(id = 'hex',bottomFace = 'green',
    #           frontFace =  FALSE,
    #           topFace = FALSE,
    #           rightFace= FALSE,
    #           leftFace = 'white',rearFace = 'FIREBRICK',
    #           width = 148, height = 148, depth = 148,rotate = c(y = tau/8, x = -tau/8)
    # ) %>%
    shape_box(id = 'headFront',
              addTo = 'dogAnchor',
              width = 40, depth = 20,height =25,
              stroke = 10,leftFace = '#EA0', rightFace = '#EA0', color = '#E62',
              translate = c(z = -10, y = 5)) %>%
    shape_box(id = 'headBack',
              addTo = 'dogAnchor',
              width = 50, depth = 40,height =60,
              stroke = 10,leftFace = '#EA0', rightFace = '#EA0', color = '#E62',
              translate = c(z = -50)) %>%
    group(id ='eyeGroup',addTo='dogAnchor') %>%
    shape_shape(id = 'leftEye', addTo = 'eyeGroup',color= '#636',translate = c(y = -20, z= -20, x = -20),stroke = 10) %>%
    shape_shape(id = 'leftEye', addTo = 'eyeGroup',color ='#636',translate = c(y = -20, z= -20, x = 20),stroke = 10) %>%
    shape_ellipse(id = 'nose', addTo = 'dogAnchor',color = '#636f', quarters = 2,translate = c(z = 10) ,diameter = 20,stroke = 10,rotate = c(z = tau/4)) %>%
    anchor(id = 'mainEarAnchor',addTo = 'dogAnchor', translate = c(y = -20, z = -45)) %>%
    anchor(id = 'leftEarAnchor', addTo = 'mainEarAnchor', translate = c(x = -40),rotate = c(z = tau/16)) %>%
    anchor(id = 'rightEarAnchor', addTo = 'mainEarAnchor', translate = c(x = 40),rotate = c(z = -tau/16)) %>%
    shape_ellipse(addTo = 'leftEarAnchor', id = 'leftEar', color = '#636', quarters = 2,
                  diameter = 40,
                  stroke = 10, rotate = c(y = -tau/4, x = -tau/16, z = -tau/16)) %>%

    shape_ellipse(addTo = 'rightEarAnchor', id = 'rightEar', color = '#636', quarters = 2,
                  diameter = 40,
                  stroke = 10, rotate = c(y = -tau/4, x = -tau/16, z = -tau/16)) %>%
    anchor(id = 'tongueAnchor',addTo = 'dogAnchor',translate = c(z = -20,y = 25)) %>%
    shape_shape(addTo = 'tongueAnchor', id = 'tongue',stroke = 10, color = '#636',
                path = list(c(y = 0,x = 10,z = 0),
                            c(y = 0, x = -10,z = 0),
                            c(y = 25, x = -10, z = 0),
                            arc = list(c(y = 35, x = 0, z = 0),
                                       c(y = 25, x = 10, z = 0))),rotate= c(x = tau/8)) %>%
    zfont_font(id = 'font') %>%
    zfont_text(zfont = 'font',text = 'rdog',color = '#E62',stroke = 2,fontSize = 35,translate = c(y = 85),textAlign = 'center')   %>%
    ## animation_none()
    # animation_ease_in(framesPerCycle = 120,pause = 120, power = 100,rotateAxis = 'y') %>% record_gif(file = 'logo.gif', duration = 15)
    animation_ease_in(framesPerCycle = 200,pause = 300, power = 30,rotateAxis = 'y')# %>%
    record_gif(file = 'logo.gif',duration = 7)
