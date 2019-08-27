Rdog_variables = {};
Rdog_variables.animations = {};
Rdog_variables.fonts = {};
Rdog_variables.animFuns = {};
Rdog_variables.animRotating_objects = {};
Rdog_variables.animation_variables = {};


Rdog_variables.utils = {};

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
        window[add_to].rotate.x = Rdog_variables.animRotating_objects[add_to].rotate.x;
        window[add_to].rotate.y = Rdog_variables.animRotating_objects[add_to].rotate.y;
        window[add_to].rotate.z = Rdog_variables.animRotating_objects[add_to].rotate.z;

        window[illo_id].rotate.x = Rdog_variables.animRotating_objects[illo_id].rotate.x;
        window[illo_id].rotate.y = Rdog_variables.animRotating_objects[illo_id].rotate.y;
        window[illo_id].rotate.z = Rdog_variables.animRotating_objects[illo_id].rotate.z;

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


        window[illo_id].updateRenderGraph();
        requestAnimationFrame( Rdog_variables.animFuns[id] );
    };
    Rdog_variables.animFuns[id]();

};
