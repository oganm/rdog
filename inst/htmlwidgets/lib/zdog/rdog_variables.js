Rdog_variables = {};
Rdog_variables.animations = {};
Rdog_variables.fonts = {};
Rdog_variables.animFuns = {};
Rdog_variables.animRotating_objects = {};
Rdog_variables.animation_variables = {};
Rdog_variables.utils = {};
Rdog_variables.svg = {};


// set up animation arguments that are used to preserve element rotation
// between updates and prevent applying the same animation
// multiple times
Rdog_variables.utils.set_up_vars = function(id, add_to, illo_id){

    // if the associated object has no animation create a copy of the object to have
    // an internal copy of the object to recover when there's a change
    if( Rdog_variables.animRotating_objects[add_to] === undefined){
        Rdog_variables.animRotating_objects[add_to] = window[add_to];
    }

    // in all cases, take a copy of the entire illustration since it is subject
    // to rotation changes by dragging
    if( Rdog_variables.animRotating_objects[illo_id] === undefined){
        Rdog_variables.animRotating_objects[illo_id] = window[illo_id];
    }

    // this is to prevent animation loops with the same id being rerun
    // if this number is greater than 1 that means the current execution
    // is happening after a restart
    if(Rdog_variables.animations[id] === undefined){
        Rdog_variables.animations[id] = 1;
    } else{
        Rdog_variables.animations[id] += 1;
    }


    // if the current execution is happening after a restart, give the rotation of the
    // rotating element to the real element so that the rotation angle is not reset
    if( Rdog_variables.animations[id] > 1){

        Object.getOwnPropertyNames(Rdog_variables.animRotating_objects).forEach(
            function(element){
                window[element].rotate.x = Rdog_variables.animRotating_objects[element].rotate.x;
                window[element].rotate.y = Rdog_variables.animRotating_objects[element].rotate.y;
                window[element].rotate.z = Rdog_variables.animRotating_objects[element].rotate.z;


                window[element].translate.x = Rdog_variables.animRotating_objects[element].translate.x;
                window[element].translate.y = Rdog_variables.animRotating_objects[element].translate.y;
                window[element].translate.z = Rdog_variables.animRotating_objects[element].translate.z;

            }
        );

    }

};


// this function checks to see if we are launching a secondary iteration
// of the same animation function if it is secondary, it terminates itself
// and reduces the secondary counter to prevent the original animation
// to terminate as well.
Rdog_variables.utils.terminationCheck = function(id, frames){
    if(Rdog_variables.animations[id] > 1 && frames == Infinity){
        Rdog_variables.animations[id] -=1;
        return true;
    } else if(frames<1){
        Rdog_variables.animations[id] -=1;
        return true;
    } else {
        return false;
    }

};


Rdog_variables.built_in = {};


// basic animation loop that doesn't try to move  anyting
Rdog_variables.built_in.animation_none = function(id, add_to, illo_id){
    Rdog_variables.utils.set_up_vars(id, add_to, illo_id);

    Rdog_variables.animFuns[id]= function(){
        if(Rdog_variables.utils.terminationCheck(id, Infinity)){
            return;
        }

        // record any changes to the original object and illustration
        Rdog_variables.animRotating_objects[add_to] = window[add_to];
        Rdog_variables.animRotating_objects[illo_id] = window[illo_id];


        window[illo_id].updateRenderGraph();
        requestAnimationFrame( Rdog_variables.animFuns[id] );
    };
    Rdog_variables.animFuns[id]();

};

Rdog_variables.built_in.animation_rotate = function(id, add_to, illo_id, frames, x, y, z){
    Rdog_variables.utils.set_up_vars(id, add_to, illo_id);

    Rdog_variables.animFuns[id] = function(){

        if(Rdog_variables.utils.terminationCheck(id, frames)){
            return;
        }
        frames -= 1;

        window[add_to].rotate.x += x;
        window[add_to].rotate.y += y;
        window[add_to].rotate.z += z;

        // record any changes to the original object
        Rdog_variables.animRotating_objects[add_to] = window[add_to];
        Rdog_variables.animRotating_objects[illo_id] = window[illo_id];


        window[illo_id].updateRenderGraph();
        requestAnimationFrame( Rdog_variables.animFuns[id] );
    };
    Rdog_variables.animFuns[id]();

};



Rdog_variables.built_in.animation_ease_in = function(id, add_to, illo_id, frames, framesPerCycle, pause, radiansPerCycle, rotateAxis, power){
    Rdog_variables.utils.set_up_vars(id, add_to, illo_id);

    // keep the needed variables in a globally accessible object instead of using
    // let to prevent values from getting lost if the original function is terminated.
    if (Rdog_variables.animation_variables[id] === undefined){
        Rdog_variables.animation_variables[id] = {};
        Rdog_variables.animation_variables[id].ticker = 1;
        Rdog_variables.animation_variables[id].pausing = false;
        Rdog_variables.animation_variables[id].pauseTicker = pause;
    }

    //ticker = 0

    Rdog_variables.animFuns[id]= function(){
        if(Rdog_variables.utils.terminationCheck(id, frames)){
            return;
        }
        frames -= 1;

        let ticker = Rdog_variables.animation_variables[id].ticker;
        let pausing = Rdog_variables.animation_variables[id].pausing;

        if(!pausing){
            let progress = ticker/framesPerCycle;
            let previousProgress = (ticker-1)/framesPerCycle;
            let rotation = Zdog.easeInOut( progress % 1, power );
            let previousRotation = Zdog.easeInOut( (ticker-1)/framesPerCycle % 1, power );
            let delta = 0;

            if(rotation>previousRotation){
                delta = rotation - previousRotation;
            } else{
                if(pause>0){
                    Rdog_variables.animation_variables[id].pausing = true;
                }
                delta = 1+rotation-previousRotation;
            }

            window[add_to].rotate[rotateAxis] += delta * radiansPerCycle;

            ticker++;
            Rdog_variables.animation_variables[id].ticker = ticker;
        } else{
            Rdog_variables.animation_variables[id].pauseTicker -=1;
            if(Rdog_variables.animation_variables[id].pauseTicker === 0){
                Rdog_variables.animation_variables[id].pausing = false;
                Rdog_variables.animation_variables[id].pauseTicker = pause;
            }

        }



        // record any changes to the original object and illustration
        Rdog_variables.animRotating_objects[add_to] = window[add_to];
        Rdog_variables.animRotating_objects[illo_id] = window[illo_id];


        window[illo_id].updateRenderGraph();
        requestAnimationFrame( Rdog_variables.animFuns[id] );
    };
    Rdog_variables.animFuns[id]();

};

// based on https://codepen.io/dheera/pen/zQJBrx
Rdog_variables.utils.parseSTL = function(stl,add_to, color_axis, color_min, color_max, stroke){
    let stlLines = stl.split('\n');
     vertexes = [];
     vertexArray = [];
     colorArray = [];
     color = 0;

    for(var i in stlLines) {
        let line = stlLines[i].trim();
        if(line.startsWith("vertex")) {
            let tokens = line.split(' ');
            let x = parseFloat(tokens[1]);
            let y = parseFloat(tokens[2]);
            let z = parseFloat(tokens[3]);
            vertex = {x: x, y: y, z: z};
            vertexes.push({x: x, y: y, z: z});
            color += vertex[color_axis];
        }
        if(line.startsWith("endloop")) {
            vertexArray.push(vertexes);
            colorArray.push(color);
            vertexes = [];
            color = 0;
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
            path: value,
            closed: true,
            stroke:stroke,
            fill: true,
            color: color
        });
    });
};



// taken from https://codepen.io/dheera/pen/zQJBrx
// https://codepen.io/chrisgannon/pen/4ef3e5deaf41cf81415c52112ea2692c
Rdog_variables.utils.makeZdogBezier = function(_path){
    	let arr = [];
	    arr[0] = {x: _path[0].x, y: _path[0].y};
	    for(let i = 1; i < _path.length; i++) {
		    if(i % 3 === 0 ) {
			    var key = "bezier";
			    var obj = {};
			    obj[key] = [
				    {x: _path[i-2].x, y: _path[i-2].y},
				    {x: _path[i-1].x, y: _path[i-1].y},
				    {x: _path[i].x , y: _path[i].y }
			    ];
			    arr.push(obj);
		    }
	    }
	return arr;
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

    if(widget.displayType =='svg'){
        var e = evt.target;
        var dim = e.getBoundingClientRect();
        var x = evt.clientX - dim.left;
        var y = evt.clientY - dim.top;
    } else if(widget.displayType =='canvas'){
        var e = evt.target;
        var dim = e.getBoundingClientRect();
        var x = evt.clientX - dim.left;
        var y = evt.clientY - dim.top;
    }

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
        canv_ghost.style.background = 'black';
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


        var colorStep = 0

        var setColor = function(child){
          if(child.color !== undefined){
              child.color = Rdog_variables.utils.incrementColor("#000001",colorStep);
              colorStep += 1;
          }
          if(child.backface!==undefined){
              child.backface = Rdog_variables.utils.incrementColor("#000001",colorStep);
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
        console.log(coordX + ' ', evt.clientX);
        var coordY = ((evt.clientY - rect.top) / (rect.bottom - rect.top) *  realCanvas.height) * canv_ghost.height/realCanvas.height;
        console.log(coordY + ' ', evt.clientY);

        var context = canv_ghost.getContext('2d');
        var imageData = context.getImageData(coordX, coordY, 1, 1 );
        var data = imageData.data;
        var rgb =  Rdog_variables.utils.rgbToHex(data[ 0 ], data[ 1 ], data[ 2 ]);
        var colorToInt = parseInt(rgb.substr(1), 16)
        colorToInt = parseInt(rgb.substr(1), 16),
        console.log(rgb)
    } else{
        var colorToInt = 0;
    }

    var message = {
        x: x,
        y: y,
        objectId: colorToInt,
        nonce: Math.random(),
        animations: Rdog_variables.animations
    };

    window.message = message;

    if("Shiny" in window){
        Shiny.onInputChange(id,message);
    }

    console.log(colorToInt)
    console.log('x: '+x+' y:'+y);

};
