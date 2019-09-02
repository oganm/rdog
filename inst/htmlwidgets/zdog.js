HTMLWidgets.widget({

  name: "zdog",

  type: "output",

  factory: function(el, width, height) {


    return {
      renderValue: function(x) {
        console.log("we're in");
        console.log(x.canvasID);
        window.debugX=  x;

        var canv = document.createElement('canvas');
        canv.id = x.canvasID;
        canv.height= x.height;
        canv.width = x.width;
        canv.style.background = x.background;
        var parentElement = document.getElementById(el.id);

        // experiment to detect clicks
        // var canv_ghost = document.createElement('canvas');
        // canv_ghost.id = x.canvasID+'_ghost';
        // canv_ghost.height= x.height;
        // canv_ghost.width = x.width;
        // canv_ghost.style.background = 'black';
        //canv_ghost.style.display="none";




        while (parentElement.firstElementChild !== null  ){
          document.getElementById(el.id).removeChild(document.getElementById(el.id).firstElementChild);
        }


        if(x.fonts !== null){
          x.fonts.forEach(function(element){
            console.log(element.id);
            let font = document.createElement('link');
            font.href = element.font;
            font.id = element.id + '-attachment';
            document.getElementById(el.id).appendChild(font);
          });
        }





        document.getElementById(el.id).appendChild(canv);
        // document.getElementById(el.id).appendChild(canv_ghost);


        eval(x.jsCode);

        eval(x.illId + ".updateRenderGraph()");


      },

      resize: function(width, height) {

      },

    };
  }
});
