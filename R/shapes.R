#' Ellipse
#'
#' Add an elipse to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param diameter Diameter of the circle
#' @param width,height Width and height of the ellipse. Overrides diameter
#' @param quarters How many quarters should be drawn. 4 draws a whole circle, 2
#' is a semi circle etc.
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_ellipse = function(rdog = NULL,
                         id = NULL,
                         diameter = 1,
                         width = diameter,
                         height = diameter,
                         quarters = 4,
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
                         scale = c(x = 1, y = 1, z = 1)
){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)


    assertthat::assert_that(assertthat::is.string(id))


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

    assertthat::assert_that(assertthat::is.number(width))
    assertthat::assert_that(assertthat::is.number(height))
    assertthat::assert_that(assertthat::is.number(diameter))
    assertthat::assert_that(assertthat::is.number(quarters))


    selfString = glue::glue(
        'width: <width>,
        height: <height>,
        quarters: <quarters>',
        .close = '>',.open = '<'
    )


    fullString = glue::glue(
        '<id> = new Zdog.Ellipse({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'ellipse')
}


#' Rectangle
#'
#' Add a rectangle to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param width,height Width and height of the rectangle.
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_rect = function(
    rdog = NULL,
    id = NULL,
    width = 1,
    height = 1,
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

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))

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

    assertthat::assert_that(assertthat::is.number(width))
    assertthat::assert_that(assertthat::is.number(height))

    selfString = glue::glue(
        'width: <width>,
        height: <height>',
        .close = '>',.open = '<'
    )

    fullString = glue::glue(
        '<id> = new Zdog.Rect({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )



    process_shape_output(rdog, id, addTo, fullString, 'rect')

}



#' Rounded rectangle
#'
#' Add a rectangle to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param width,height Width and height of the rectangle.
#' @param cornerRadius Radius of the rounded corners
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_roundedRect = function(
    rdog = NULL,
    id = NULL,
    width = 1,
    height = 1,
    cornerRadius = 0.25,
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
    scale = c(x = 1, y = 1, z = 1)
){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))

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

    assertthat::assert_that(assertthat::is.number(width))
    assertthat::assert_that(assertthat::is.number(height))
    assertthat::assert_that(assertthat::is.number(cornerRadius))

    selfString = glue::glue(
        'width: <width>,
        height: <height>,
        cornerRadius: <cornerRadius>',
        .close = '>',.open = '<'
    )

    fullString = glue::glue(
        '<id> = new Zdog.RoundedRect({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'roundedRect')

}



#' Polygon
#'
#' Add a polygon to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param radius Size of the polygon
#' @param sides Number of sides for the polygon
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_polygon = function(
    rdog = NULL,
    id = NULL,
    radius = 0.5,
    sides = 3,
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
    scale = c(x = 1, y = 1, z = 1)
){
    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    if(is.null(id)){
        id = basename(tempfile(pattern = 'id'))
    }

    assertthat::assert_that(assertthat::is.string(id))

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

    assertthat::assert_that(assertthat::is.number(radius))
    assertthat::assert_that(sides%%1 == 0)

    selfString = glue::glue(
        'radius: <radius>,
        sides: <sides>',
        .close = '>',.open = '<'
    )

    fullString = glue::glue(
        '<id> = new Zdog.Polygon({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'polygon')

}


#' A shape
#'
#' Add a shape to an illustration defined by its path. If not path is
#' provided, a point will be drawn.
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param path Path of the shape. A named list of instructions
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_shape = function(
    rdog = NULL,
    id = NULL,
    path = NULL,
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
    scale = c(x = 1, y = 1, z = 1)
){
    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))

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

    if(!is.null(path)){
        assertthat::assert_that(is.list(path))

        seq_along(path) %>% sapply(function(i){
            if(is.null(names(path)[i]) | names(path)[i] == ''){
                assertthat::assert_that(!is.list(path[[i]]),msg = 'Nested elements in path must have names')
                return(process_coord_vector(path[[i]]))
            } else{
                if(is.list(path[[i]])){
                return(
                       glue::glue('{ !names(path)[i]@: [\n!path[[i]] %>% lapply(process_coord_vector) %>% c(list(sep=",\n")) %>% do.call(paste,.)@\n]}',.close = '@',.open = '!')
                    )
                } else{
                    return(
                        glue::glue('{ <names(path)[i]>: <process_coord_vector(path[[i]])> }',.open = '<',.close = '>')
                    )
                }
            }
        }) %>% c(list(sep = ',\n')) %>% do.call(paste,.) -> pathString

        selfString = glue::glue(
            'path: [<pathString>]',
            .close = '>',.open = '<'
        )

        fullString = glue::glue(
            '<id> = new Zdog.Shape({
                <selfString>,
                <shapeString>,
                <anchorString>
            })',
            .close = '>',.open = '<'
        )
    } else{
            fullString = glue::glue(
                '<id> = new Zdog.Shape({
                <shapeString>,
                <anchorString>
            })',
                .close = '>',.open = '<'
            )
    }



    process_shape_output(rdog, id, addTo, fullString, 'path')

}


#' Hemisphere
#'
#' Add a hemisphere to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param diameter Diameter of the circle
#' @param height,width Height and width of the base circle.
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_hemisphere = function(rdog = NULL,
                         id = NULL,
                         diameter = 1,
                         height = diameter,
                         width = diameter,
                         quarters = 4,
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
                         scale = c(x = 1, y = 1, z = 1)
){
    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))


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

    assertthat::assert_that(assertthat::is.number(diameter))
    assertthat::assert_that(assertthat::is.number(height))
    assertthat::assert_that(assertthat::is.number(width))


    selfString = glue::glue(
        'diameter: <diameter>,
        height: <height>,
        width: <width>',
        .close = '>',.open = '<'
    )


    fullString = glue::glue(
        '<id> = new Zdog.Hemisphere({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'hemisphere')

}



#' Cone
#'
#' Add a cone to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param diameter Diameter of the base circle
#' @param length length of the cone
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_cone= function(rdog = NULL,
                            id = NULL,
                            diameter = 1,
                            length = 1,
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
                            scale = c(x = 1, y = 1, z = 1)
){
    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))


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

    assertthat::assert_that(assertthat::is.number(diameter))
    assertthat::assert_that(assertthat::is.number(length))


    selfString = glue::glue(
        'diameter: <diameter>,
        length: <length>',
        .close = '>',.open = '<'
    )


    fullString = glue::glue(
        '<id> = new Zdog.Cone({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'cone')

}


#' Cylinder
#'
#' Add a cylinder to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param diameter Diameter of the cylinder
#' @param length of the cylinder
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_cylinder= function(rdog = NULL,
                     id = NULL,
                     diameter = 1,
                     length = 1,
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
                     scale = c(x = 1, y = 1, z = 1)
){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))


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

    assertthat::assert_that(assertthat::is.number(diameter))
    assertthat::assert_that(assertthat::is.number(length))


    selfString = glue::glue(
        'diameter: <diameter>,
        length: <length>',
        .close = '>',.open = '<'
    )


    fullString = glue::glue(
        '<id> = new Zdog.Cylinder({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'cylinder')

}


#' Box
#'
#' Add a box to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param width,height,depth Dimensions of the box
#' @param frontFace,rearFace,leftFace,rightFace,topFace,bottomFace Face colors of the box. Set FALSE to remove
#' @inheritParams shape
#' @inheritParams anchor
#'
#' @export
shape_box= function(rdog = NULL,
                         id = NULL,
                         width = 1,
                         height = 1,
                         depth = 1,
                         frontFace = '#333',
                         rearFace = '#333',
                         leftFace = '#333',
                         rightFace = '#333',
                         topFace = '#333',
                         bottomFace = '#333',
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
                         scale = c(x = 1, y = 1, z = 1)
){
    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))


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

    assertthat::assert_that(assertthat::is.number(width))
    assertthat::assert_that(assertthat::is.number(height))
    assertthat::assert_that(assertthat::is.number(depth))
    assertthat::assert_that(is.logical(frontFace) | assertthat::is.string(frontFace))
    assertthat::assert_that(is.logical(rearFace) | assertthat::is.string(rearFace))
    assertthat::assert_that(is.logical(leftFace) | assertthat::is.string(leftFace))
    assertthat::assert_that(is.logical(rightFace) | assertthat::is.string(rightFace))
    assertthat::assert_that(is.logical(topFace) | assertthat::is.string(topFace))
    assertthat::assert_that(is.logical(bottomFace) | assertthat::is.string(bottomFace))


    selfString = glue::glue(
        'width: <width>,
        height: <height>,
        depth: <depth>,
        frontFace: <if(is.logical(frontFace)){tolower(frontFace)}else{paste0("\'",frontFace,"\'")}>,
        rearFace: <if(is.logical(rearFace)){tolower(rearFace)}else{paste0("\'",rearFace,"\'")}>,
        leftFace: <if(is.logical(leftFace)){tolower(leftFace)}else{paste0("\'",leftFace,"\'")}>,
        rightFace: <if(is.logical(rightFace)){tolower(rightFace)}else{paste0("\'",rightFace,"\'")}>,
        topFace: <if(is.logical(topFace)){tolower(topFace)}else{paste0("\'",topFace,"\'")}>,
        bottomFace: <if(is.logical(bottomFace)){tolower(bottomFace)}else{paste0("\'",bottomFace,"\'")}>
        ',
        .close = '>',.open = '<'
    )


    fullString = glue::glue(
        '<id> = new Zdog.Box({
            <selfString>,
            <shapeString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'box')

}


#' Anchor
#' @param rdog rdog object to add the anchor to
#' @param id id of the anchor. If NULL, a random id will be assigned
#' @inheritParams anchor
#' @export
anchor = function(
    rdog = NULL,
    id = NULL,
    addTo = NULL,
    translate = c(x =0, y=0,z=0),
    rotate = c(x = 0, y = 0, z = 0),
    scale = c(x = 1, y = 1, z = 1)
){

    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    anchorString = internal_anchor(addTo,
                                   translate,
                                   rotate,
                                   scale)

    fullString = glue::glue(
        '<id> = new Zdog.Anchor({
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'anchor')

}



#' Cylinder
#'
#' Add a cylinder to an illustration
#'
#' @param rdog rdog object to add the shape to
#' @param id id of the shape. If NULL, a random id will be assigned
#' @param updateSort
#' @param visible
#' @inheritParams anchor
#'
#' @export
group= function(rdog = NULL,
                id = NULL,
                addTo = NULL,
                updateSort = FALSE,
                visible = TRUE,
                translate = c(x =0, y=0,z=0),
                rotate = c(x = 0, y = 0, z = 0),
                scale = c(x = 1, y = 1, z = 1)
){
    c(addTo,id,illoId) %<-% process_id_inputs(rdog, addTo, id)

    assertthat::assert_that(assertthat::is.string(id))


    anchorString = internal_anchor(addTo,
                                   translate,
                                   rotate,
                                   scale)


    assertthat::assert_that(is.logical(updateSort))
    assertthat::assert_that(is.logical(visible))


    selfString = glue::glue(
        'updateSort: <tolower(updateSort)>,
        visible: <tolower(visible)>',
        .close = '>',.open = '<'
    )


    fullString = glue::glue(
        '<id> = new Zdog.Group({
            <selfString>,
            <anchorString>
        })',
        .close = '>',.open = '<'
    )

    process_shape_output(rdog, id, addTo, fullString, 'group')

}
