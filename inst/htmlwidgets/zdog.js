HTMLWidgets.widget({

  name: "zdog",

  type: "output",

  factory: function(el, width, height) {


    return {
      renderValue: function(x) {
        console.log('something');
        console.log(x.canvasID)
        window.debugX=  x;

        var canv = document.createElement('canvas');
        canv.id = x.canvasID;
        canv.height= x.height;
        canv.width = x.width;
        canv.style.background = x.background;
        var parentElement = document.getElementById(el.id);





        while (parentElement.firstElementChild !== null  ){
          document.getElementById(el.id).removeChild(document.getElementById(el.id).firstElementChild);
        }

        x.fonts.forEach(function(element){
          console.log(element.id);
          let font = document.createElement('link');
          font.href = element.font;
          font.id = element.id + '-attachment';
          document.getElementById(el.id).appendChild(font);
        });



        document.getElementById(el.id).appendChild(canv);
        eval(x.jsCode);


      },

      resize: function(width, height) {

      },

    };
  }
});
