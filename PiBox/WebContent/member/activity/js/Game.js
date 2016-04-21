function init(commandId) {
		alert('commandId' + commandId);
              //Find our div containers in the DOM
              var dataContainerOrientation = document.getElementById('dataContainerOrientation');
              var dataContainerMotion = document.getElementById('dataContainerMotion');
              var halfway = 0;
              var alpha;
              var beta;
              var gamma;
              var result = false;
              // var sel= document.getElementById('commandlist');
              var sel = commandId;
              option = sel.options[sel.selectedIndex].value;
                        if ( option == "left"){
                           positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Keep your mobile vertical, then rotate left</i></b></h2>';
                        //   var htmlcontent = '<h2 style="color:brown"><b><i>Keep your mobile vertical, then rotate left</i></b></h2>';
                        //   swal({
                        //           title: "Move"+option,
                        //           text: htmlcontent,
                        //           html: true
                        //       });
                        }
                        else if (option == "right")
                          positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Keep your mobile vertical, then rotate right</i></b></h2>';
                        else if ( option == "up")
                          positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Keep your mobile horizontal, then flipup</i></b></h2>';
                        else if (option == "down")
                          positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Keep your mobile horizontal, then flipdown</i></b></h2>';
                        else
                          positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Select a game option</i></b></h2>';
              //Check for support for DeviceOrientation event
              if(window.DeviceOrientationEvent) {
                window.addEventListener('deviceorientation', function(event) {
                        alpha = Math.round(event.alpha);
                        beta = Math.round(event.beta);
                        gamma = Math.round(event.gamma);
                        if(alpha!=null || beta!=null || gamma!=null)
                          dataContainerOrientation.innerHTML = 'alpha: ' + alpha + '<br/>beta: ' + beta + '<br />gamma: ' + gamma;
                        if ( option == "left")
                          rotateleft();
                        else if (option == "right")
                          rotateright();
                        else if ( option == "up")
                          flipup();
                        else if (option == "down")
                          flipdown();
                        else
                          return;
                      }, false);
              }
              function rotateleft(){
                if (halfway==0 && beta > 65 && beta <115){
                  positionInfo.innerHTML = '<h2 style="color:blue"><b><i>Good, Now rotate left</i></b></h2>';
                  halfway = 1;
                }
                if (halfway==1 && alpha >65 && alpha < 120){
                  positionInfo.innerHTML = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                  halfway = 2;
                  result = true;
                }
              }
              function rotateright(){
                if (halfway==0 && beta > 65 && beta <115){
                  positionInfo.innerHTML = '<h2 style="color:blue"><b><i>Good, Now rotate right</i></b></h2>';
                  halfway = 1;
                }
                if (halfway==1 && alpha < 280 && alpha > 250){
                  positionInfo.innerHTML = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                  halfway = 2;
                  result = true;
                }
              }
              function flipup(){ //yet to be altered
                if (halfway==0 && beta > -15 && beta <15){
                  positionInfo.innerHTML = '<h2 style="color:blue"><b><i>Good, Now flipup</i></b></h2>';
                  halfway = 1;
                }
                if (halfway==1 && beta >65 && beta < 115){
                  positionInfo.innerHTML = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                  halfway = 2;
                  result = true;
                }
              }
              function flipdown(){ //yet to be altered
                if (halfway==0 && beta > -15 && beta <15){
                  positionInfo.innerHTML = '<h2 style="color:blue"><b><i>Good, Now flipdown</i></b></h2>';
                  halfway = 1;
                }
                if (halfway==1 && beta < -65 && beta > -120){
                  positionInfo.innerHTML = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                  halfway = 2;
                  result = true;
                }
              }
              return Boolean(result);
            }