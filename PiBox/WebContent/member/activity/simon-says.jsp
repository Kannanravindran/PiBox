</html>
      <head>
        <link rel="stylesheet" type="text/css" href="sweetalert-master/dist/sweetalert.css">
        <script src="sweetalert-master/dist/sweetalert.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
        <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
      </head>
      <body>
        <p align ="center"><h1> Simon Says ... </h1><br>
        <h2> Select a game mode </h2>
        <h3><select id="commandlist" onChange="init()">
          <option class="placeholder" selected disabled value="" > Select game option</option>
          <option value="left">Turn Left</option>
          <option value="right">Turn Right</option>
          <option value="up">Turn up</option>
          <option value="down">Turn Down</option>
        </select></h3>
        </p>
        <!--
        <script>
        $("#commandlist").change(function() {
            swal({
              title: "Tilt",
              text: "You have only 3 seconds to play",
              showConfirmButton:false,
              timer: 3000
            });
        });
        </script>
        -->
        <script>
        function init() {
              //Find our div containers in the DOM
              var dataContainerOrientation = document.getElementById('dataContainerOrientation');
              var dataContainerMotion = document.getElementById('dataContainerMotion');
              var halfway = 0;
              var alpha;
              var beta;
              var gamma;
              var xhttp = new XMLHttpRequest();
              var id;
              var score = 0;
              var sel= document.getElementById('commandlist');
              option = sel.options[sel.selectedIndex].value;
                        if ( option == "left"){
                          // positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Keep your mobile vertical, then rotate left</i></b></h2>';
                          var htmlcontent = '<h2 style="color:brown"><b>Keep your mobile vertical, then rotate left</b></h2>';
                          swal({
                                   title: "Simon says rotate "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                        }
                        else if (option == "right"){
                          var htmlcontent =  '<h2 style="color:brown"><b>Keep your mobile vertical, then rotate right</b></h2>';
                          // positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Keep your mobile vertical, then rotate right</i></b></h2>';
                          swal({
                                   title: "Simon says rotate "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                        }
                        else if ( option == "up"){
                          // positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Keep your mobile horizontal, then flipup</i></b></h2>';
                          var htmlcontent = '<h2 style="color:brown"><b>Keep your mobile horizontal, then flipup</b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                        }
                        else if (option == "down"){
                          // positionInfo.innerHTML = '<h2 style="color:brown"><b><i>Keep your mobile horizontal, then flipdown</i></b></h2>';
                          var htmlcontent = '<h2 style="color:brown"><b>Keep your mobile horizontal, then flipdown</b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 10000
                              });
                        }
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
                  // positionInfo.innerHTML = '<h2 style="color:blue"><b><i>Good, Now rotate left</i></b></h2>';
                  var htmlcontent = '<h2 style="color:blue"><b><i>Good, Now rotate left</i></b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                  halfway = 1;
                }
                if (halfway==1 && alpha >65 && alpha < 120){
                  // positionInfo.innerHTML = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                  var htmlcontent = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                  halfway = 2;
                  score = score +5;
                  url = 'https://localhost:8443/PiBox/api/rest/sessions/1/'+id;
                  xhttp.open("POST", url, true);
                  xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
                  xhttp.send("score="+score);
                }
              }
              function rotateright(){
                if (halfway==0 && beta > 65 && beta <115){
                  // positionInfo.innerHTML = '<h2 style="color:blue"><b><i>Good, Now rotate right</i></b></h2>';
                  var htmlcontent = '<h2 style="color:blue"><b><i>Good, Now rotate right</i></b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                  halfway = 1;
                }
                if (halfway==1 && alpha < 280 && alpha > 250){
                  // positionInfo.innerHTML = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                  var htmlcontent = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                  halfway = 2;
                  score = score +5;
                  url = 'https://localhost:8443/PiBox/api/rest/sessions/1/'+id;
                  xhttp.open("POST", url, true);
                  xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
                  xhttp.send("score="+score);
                }
              }
              function flipup(){ //yet to be altered
                if (halfway==0 && beta > -15 && beta <15){
                  // positionInfo.innerHTML = '<h2 style="color:blue"><b><i>Good, Now flipup</i></b></h2>';
                  var htmlcontent = '<h2 style="color:blue"><b><i>Good, Now flipup</i></b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                  halfway = 1;
                }
                if (halfway==1 && beta >65 && beta < 115){
                  // positionInfo.innerHTML = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                  var htmlcontent = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                  halfway = 2;
                  score = score +5;
                  url = 'https://localhost:8443/PiBox/api/rest/sessions/1/'+id;
                  xhttp.open("POST", url, true);
                  xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
                  xhttp.send("score="+score);
                }
              }
              function flipdown(){ //yet to be altered
                if (halfway==0 && beta > -15 && beta <15){
                  // positionInfo.innerHTML = '<h2 style="color:blue"><b><i>Good, Now flipdown</i></b></h2>';
                  var htmlcontent = '<h2 style="color:blue"><b><i>Good, Now flipdown</i></b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                  halfway = 1;
                }
                if (halfway==1 && beta < -65 && beta > -120){
                  // positionInfo.innerHTML = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                  var htmlcontent = '<h2 style="color:green"><b><i>Awesome, You did it</i></b></h2>';
                          swal({
                                   title: "Simon says flip "+option,
                                   text: htmlcontent,
                                   showConfirmButton:false,
                                   html: true,
                                   timer: 3000
                              });
                  halfway = 2;
                  score = score +5;
                  url = 'https://localhost:8443/PiBox/api/rest/sessions/1/'+id;
                  xhttp.open("POST", url, true);
                  xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
                  xhttp.send("score="+score);
                }
              }
            }
        </script>
        <div id="dataContainerOrientation">
          No device orientation data
        </div>
        <div id="dataContainerMotion">

        </div>
        <br>
        <div id = "positionInfo">
          <h2 style="color:black"><b><i>Please select a game option</i></b></h2>
        </div>
        <div>
          <h2></h2>
        </div>
        <br>
        <form>
        <h2><input type="button" onClick = "history.go(0)" value="Reset Game"></h2>
        </form>
      </body>
    </html>