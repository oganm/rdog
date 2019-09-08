HTMLWidgets.widget({

  name: "zdog",

  type: "output",

  factory: function(el, width, height) {


    return {
      renderValue: function(x) {
        window.debugX=  x;

        if(x.displayType == 'canvas'){
          var canv = document.createElement('canvas');
          canv.id = x.canvasID;
          canv.height= x.height;
          canv.width = x.width;
          canv.style.background = x.background;


          canv.addEventListener('click', function(event){
            Rdog_variables.utils.clicked(event, 'svg', el.id, x.height, x.width, x.centered);
          }, false);

          //canv.onclick = "Rdog_variables.utils.clicked(evt,'svg'," + x.canvasID + ", " + x.height + ", " + x.width + ", " + x.centered+ ")" ;
        } else if(x.displayType == 'svg'){
           var canv = document.createElementNS("http://www.w3.org/2000/svg","svg");
           canv.setAttribute("height", x.height);
           canv.setAttribute("width", x.width);
           canv.setAttribute("id", x.canvasID);
           canv.setAttribute("onclick","Rdog_variables.utils.clicked(evt,'svg'," + el.id + ", " + x.height + ", " + x.width + ", " + x.centered+ ")" );
           canv.style.background = x.background;
        }


        //console.log(illo_clicked)


        var parentElement = document.getElementById(el.id);

        // experiment to detect clicks
        // var canv_ghost = document.createElement('canvas');
        // canv_ghost.id = x.canvasID+'_ghost';
        // canv_ghost.height= x.height;
        // canv_ghost.width = x.width;
        // canv_ghost.style.background = 'black';
        // canv_ghost.style.display="none";




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
