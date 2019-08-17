HTMLWidgets.widget({

  name: "zdog",

  type: "output",

  factory: function(el, width, height) {


    return {
      renderValue: function(x) {
        console.log("we're in");
        console.log(x.canvasID);
        window.debugX=  x;
        console.log('stopAnimation_' + x.illId in window);
        if('stopAnimation_' + x.illId in window){
          console.log('stopping animation');
          eval('window.stopAnimation_' + x.illId + '=true')
          console.log(eval('window.stopAnimation_' + x.illId))
        }

        var canv = document.createElement('canvas');
        canv.id = x.canvasID;
        canv.height= x.height;
        canv.width = x.width;
        canv.style.background = x.background;
        var parentElement = document.getElementById(el.id);





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
        eval(x.jsCode);

        eval(x.illId + ".updateRenderGraph()");


      },

      resize: function(width, height) {

      },

    };
  }
});
