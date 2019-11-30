Rdog_variables = {};
Rdog_variables.animations = {};
Rdog_variables.fonts = {};
Rdog_variables.animFuns = {};
Rdog_variables.animRotating_objects = {};
Rdog_variables.animation_variables = {};
Rdog_variables.utils = {};
Rdog_variables.svg = {};
Rdog_variables.built_in = {};
Rdog_variables.objects = {};


// based on https://codepen.io/dheera/pen/zQJBrx
Rdog_variables.utils.parseSTL = function(stl,add_to, color_axis, color_min, color_max, stroke, colorMode, offset){
    let stlLines = stl.split('\n');
     var vertexes = [];
     var vertexArray = [];
     var colorArray = [];
     var color = 0;

    for(var i in stlLines) {
        let line = stlLines[i].trim();
        if(line.startsWith("vertex")) {
            let tokens = line.split(' ');
            let x = parseFloat(tokens[1]);
            let y = parseFloat(tokens[2]);
            let z = parseFloat(tokens[3]);
            vertex = {x: x, y: y, z: z};
            vertexes.push({x: x, y: y, z: z});
            if(colorMode == 'mean'){
                color += vertex[color_axis];
            } else if(colorMode =='ordered'){
                color += 1;
            }
        }
        if(line.startsWith("endloop")) {
            vertexArray.push(vertexes);
            if(colorMode == 'mean' || colorMode =='ordered'){
                colorArray.push(color);
            } else if(colorMode =='extreme'){
                min = Math.min(vertexes[1][color_axis], vertexes[0][color_axis], vertexes[2][color_axis]);
                max = Math.max(vertexes[1][color_axis], vertexes[0][color_axis], vertexes[2][color_axis]);
                colorArray.push(min+max);
            }
            vertexes = [];
            if(colorMode =='mean'){
                color = 0;
            }
        }
    }

    min_color_rgb = Rdog_variables.utils.hexToRgb(color_min);
    max_color_rgb = Rdog_variables.utils.hexToRgb(color_max);

    max_color = Math.max(...colorArray);
    min_color = Math.min(...colorArray);
    vertexArray.forEach(function(value, i){

        let colorWeight = (colorArray[i] - min_color)/(max_color - min_color);

        let colorRgb = Rdog_variables.utils.getGradient(min_color_rgb, max_color_rgb, colorWeight);
        let color  = Rdog_variables.utils.rgbToHex(colorRgb.r,colorRgb.g,colorRgb.b);

        new Zdog.Shape({
            addTo: add_to,
            translate: offset,
            path: value,
            closed: true,
            stroke:stroke,
            fill: true,
            color: color
        });
    });
};




// based on https://codepen.io/eeropic/pen/rgQapW
// this is somewhat silly as we create an entirely new svg element
Rdog_variables.utils.processSVGData = function(path, svgWidth,svgHeight){
    let svg = document.createElementNS("http://www.w3.org/2000/svg","svg");
    let newpath = document.createElementNS(svg.namespaceURI,"path");

    newpath.setAttributeNS(null, "d",path);
    svg.appendChild(newpath);


    let pp = new paper.Project();
    pp.importSVG(svg);

    let compoundPath = pp.layers[0].children[0].children[0].children;

    let pathArrays = [];


    let xOffset = svgWidth/2;
    let yOffset = svgHeight/2;



    for(var pathData of compoundPath){
            let pathArray = [];
            for(var seg of pathData.segments){
                if(seg.index===0){
                    pathArray.push({x:seg.point.x-xOffset,y:seg.point.y-yOffset});
                }
                else{
                    pathArray.push({
                        bezier:[
                            {
                                x:seg.previous.point.x+seg.previous.handleOut.x-xOffset,
                                y:seg.previous.point.y+seg.previous.handleOut.y-yOffset
                            },
                            {x:seg.point.x+seg.handleIn.x -xOffset, y:seg.point.y+seg.handleIn.y -yOffset},
                            {x:seg.point.x-xOffset, y:seg.point.y-yOffset},
                            ]});
                    if(pathData.closed && seg.index==pathData.segments.length-1){
                        pathArray.push({
                            bezier:[
                                {x:seg.point.x+seg.handleOut.x-xOffset, y:seg.point.y+seg.handleOut.y-xOffset},
                                {x:seg.next.point.x+seg.next.handleIn.x-xOffset,y:seg.next.point.y+seg.next.handleIn.y-yOffset},
                                {x:seg.next.point.x-xOffset,y:seg.next.point.y-yOffset},
                                ]});
                    }
                }
            }

            pathArrays.push(pathArray);

    }

    return pathArrays;


};

// https://stackoverflow.com/questions/12934720/how-to-increment-decrement-hex-color-values-with-javascript-jquery
Rdog_variables.utils.incrementColor = function(color, step){
    var colorToInt = parseInt(color.substr(1), 16),                     // Convert HEX color to integer
        nstep = parseInt(step);                                         // Convert step to integer
    if(!isNaN(colorToInt) && !isNaN(nstep)){                            // Make sure that color has been converted to integer
        colorToInt += nstep;                                            // Increment integer with step
        var ncolor = colorToInt.toString(16);                           // Convert back integer to HEX
        ncolor = '#' + (new Array(7-ncolor.length).join(0)) + ncolor;   // Left pad "0" to make HEX look like a color
        if(/^#[0-9a-f]{6}$/i.test(ncolor)){                             // Make sure that HEX is a valid color
            return ncolor;
        }
    }
    return color;
};

// https://stackoverflow.com/questions/5623838/rgb-to-hex-and-hex-to-rgb
 Rdog_variables.utils.componentToHex = function(c){
        let hex = c.toString(16);
        return hex.length == 1 ? "0" + hex : hex;
};

 Rdog_variables.utils.rgbToHex = function(r, g, b){
        return "#" +  Rdog_variables.utils.componentToHex(r) +  Rdog_variables.utils.componentToHex(g) +  Rdog_variables.utils.componentToHex(b);
};


Rdog_variables.utils.hexToRgb = function(hex) {
  var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  if(result !== null){
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
  } else{
      result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
      return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16),
        a: parseInt(result[4], 16)
    } : null;
  }

};


// https://stackoverflow.com/questions/30143082/how-to-get-color-value-from-gradient-by-percentage-with-javascript
Rdog_variables.utils.getGradient = function(color1, color2, weight) {
    var w1 = weight;
    var w2 = 1 - w1;
    var rgb = {r: Math.round(color1.r * w1 + color2.r * w2),
        g: Math.round(color1.g * w1 + color2.g * w2),
        b: Math.round(color1.b * w1 + color2.b * w2)};
    return rgb;
};

Rdog_variables.utils.clicked = function(evt, id, widget){

    var e = evt.target;
    var dim = e.getBoundingClientRect();
    var x = evt.clientX - dim.left;
    var y = evt.clientY - dim.top;

    if(widget.centered){
        x = x - widget.width/2;
        y = y - widget.height/2;
    }

    if(widget.displayType == 'canvas'){
        var ghostCanv = document.getElementById(widget.canvasID + '_ghost');
        var parent = ghostCanv.parentElement;
        parent.removeChild(ghostCanv);

        var canv_ghost = document.createElement('canvas');
        canv_ghost.id = widget.canvasID+'_ghost';
        canv_ghost.height= widget.height;
        canv_ghost.width = widget.width;
        canv_ghost.style.background = 'white';
        canv_ghost.style.display="none";

        parent.appendChild(canv_ghost);

        window[widget.illId + '_ghost'] =
            new Zdog.Illustration({
            element: '#' + widget.canvasID + '_ghost',
            dragRotate: false,
            centered: widget.centered,
            zoom: widget.zoom,
            scale: widget.scale,
            translate: widget.translate,
            rotate: widget.rotate,
            resize: widget.resize
        });


        window[widget.illId].children.forEach(function(x){
          x.copyGraph({
              addTo: window[widget.illId + '_ghost']
          });
        });


        window[widget.illId + '_ghost'].rotate = window[widget.illId].rotate;
        window[widget.illId + '_ghost'].translate = window[widget.illId].translate;


        var colorStep = 0;
        // just for debugging purposes.
        // higher increments makes colors changes more visible
        // also comment out canv_ghost.style.display="none" above
        var colorIncrement = 1;

        var setColor = function(child){
          if(child.color !== undefined){
              colorStep += colorIncrement;
              child.color = Rdog_variables.utils.incrementColor("#000000",colorStep);
          }
          if(child.backface!==undefined && child.backface){
              // colorStep += colorIncrement;
              child.backface = Rdog_variables.utils.incrementColor("#000000",colorStep);
          }
          if(child.children.length > 0){
              child.children.forEach(setColor);
          }
        };

        window[widget.illId + '_ghost'].children.forEach(setColor);

        window[widget.illId + '_ghost'].updateRenderGraph();


        var realCanvas = document.getElementById(widget.illId);

        var rect = realCanvas.getBoundingClientRect();

        var coordX = ((evt.clientX - rect.left) / (rect.right - rect.left) * realCanvas.width)* canv_ghost.width/realCanvas.width;
        var coordY = ((evt.clientY - rect.top) / (rect.bottom - rect.top) *  realCanvas.height) * canv_ghost.height/realCanvas.height;

        var context = canv_ghost.getContext('2d');
        var imageData = context.getImageData(coordX, coordY, 1, 1 );
        var data = imageData.data;
        var rgb =  Rdog_variables.utils.rgbToHex(data[ 0 ], data[ 1 ], data[ 2 ]);
        var colorToInt = parseInt(rgb.substr(1), 16);

        var tracer = 0;
        var currentId = '';
        var findObject = function(child){
            var out = false;
            if(child.id !== undefined){
                currentId = child.id;
            }


            if(child.color !== undefined){
                tracer += 1;
                if(tracer == colorToInt/colorIncrement){
                     out = true;
                }
            }

            if(child.children.length > 0 && out == false){
              out = child.children.some(findObject);
          }

          return out;
        }

        if(colorToInt>0){
            window[widget.illId].children.some(findObject);
        }

    } else{
        var colorToInt = 0;
        var currentId = '';
    }


    var message = {
        x: x,
        y: y,
        objectId: currentId,
        objectNo: colorToInt/colorIncrement,
        nonce: Math.random(),
        animations: Rdog_variables.animations
    };

    //window.message = message;

    if("Shiny" in window){
        Shiny.onInputChange(id,message);
    }

    console.log(colorToInt/colorIncrement)
    console.log(currentId)
    console.log('x: '+x+' y:'+y);

};
