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
            }
        );

    }

};


// this function checks to see if we are launching a secondary iteration
// of the same animation function if it is secondary, it terminates itself
// and reduces the secondary counter to prevent the original animation
// to terminate as well.
Rdog_variables.utils.terminationCheck = function(id, frames){
    if(Rdog_variables.animations[id] > 1 || frames<1){
        Rdog_variables.animations[id] -=1;
        return true;
    } else{
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
        console.log(Rdog_variables.animRotating_objects[add_to].rotate);


        window[illo_id].updateRenderGraph();
        requestAnimationFrame( Rdog_variables.animFuns[id] );
    };
    Rdog_variables.animFuns[id]();

};


// taken from
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
Rdog_variables.utils.processSVGData = function(path){
    let svg = document.createElementNS("http://www.w3.org/2000/svg","svg");
    let newpath = document.createElementNS(svg.namespaceURI,"path");

    newpath.setAttributeNS(null, "d",path);
    svg.appendChild(newpath);


    pp = new paper.Project();
    pp.importSVG(svg);

    compoundPath = pp.layers[0].children[0].children[0].children

    let pathArrays = []

    for(var pathData of compoundPath){
            let pathArray = [];
            for(var seg of pathData.segments){
                if(seg.index===0){
                    pathArray.push({x:seg.point.x,y:seg.point.y});
                }
                else{
                    pathArray.push({
                        bezier:[
                            {
                                x:seg.previous.point.x+seg.previous.handleOut.x,
                                y:seg.previous.point.y+seg.previous.handleOut.y
                            },
                            {x:seg.point.x+seg.handleIn.x, y:seg.point.y+seg.handleIn.y},
                            {x:seg.point.x, y:seg.point.y},
                            ]});
                    if(pathData.closed && seg.index==pathData.segments.length-1){
                        pathArray.push({
                            bezier:[
                                {x:seg.point.x+seg.handleOut.x, y:seg.point.y+seg.handleOut.y},
                                {x:seg.next.point.x+seg.next.handleIn.x,y:seg.next.point.y+seg.next.handleIn.y},
                                {x:seg.next.point.x,y:seg.next.point.y},
                                ]});
                    }
                }
            }

            pathArrays.push(pathArray);

    }

    return pathArrays;


};
