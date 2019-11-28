<!DOCTYPE html>
<!--[if IE 9]><html lang="en-us" class="ie9"><![endif]-->
<!--[if gt IE 9]><!-->
<html lang="en-us">
<!--<![endif]-->
  <head>
    <title>OpenShift Demo Logocalis</title>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="img/logo.ico">
    <link rel="stylesheet" href="css/patternfly.min.css" >
    <link rel="stylesheet" href="css/patternfly-additions.min.css" >
    <script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery.matchHeight/0.6.0/jquery.matchHeight-min.js"></script>
    <script src="http://cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
    <script src="js/patternfly.min.js"></script>
    <script src="js/demo.js"></script>
  <body class="cards-pf">
    <nav class="navbar navbar-default" role="navigation">
      <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        <ul class="nav navbar-nav">
          <li>
            <br>
              <table>
                <tr>
                  <img src="img/logicalis-logo.png" width="150"/>
                  <td width=1700px>
                    <p align="right"> <font size="3" color="black"> Logicalis 2019  </font></p>
                  </td>
                </tr>
              </table>
            </li>
          </ul>
        </div>
      </nav>
    <div class="container-fluid container-cards-pf">
      <div class="row row-cards-pf">
        <div class="col-md-2 col-md-offset-3">
          <div class="card-pf">
            <div class="card-pf-heading">
              <h2 class="card-pf-title">
                Logger
              </h2>
            </div>
            <div class="card-pf-body">
              <div style="text-align: center;">
                <p>
                  <button class="btn btn-primary btn-block" type="button" id="loginfo">Log Info</button>
                </p>
                <p>
                  <button class="btn btn-primary btn-block" type="button" id="logwarning">Log Warning</button>
                </p>
                <p>
                  <button class="btn btn-primary btn-block" type="button" id="logerror">Log Error</button>
                </p>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-2">
          <div class="card-pf">
            <div class="card-pf-heading">
              <h2 class="card-pf-title">
                Load Generator
              </h2>
            </div>
            <div class="card-pf-body">
              <form class="form-horizontal">
                <div class="form-group">
                  <label class="control-label col-md-3" for="seconds">Seconds</label>
                  <div class="col-md-6">
                    <input type="text" id="seconds" class="form-control">
                  </div>
                </div>
                <div class="form-group">
                  <div class="col-md-12">
                    <button type="button" class="btn btn-primary btn-block" id="load">Load!</button>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </div>
        <div class="col-md-2">
          <div class="card-pf">
            <div class="card-pf-heading">
              <h2 class="card-pf-title">
                Danger Zone
              </h2>
            </div>
            <div class="card-pf-body">
              <div style="text-align: center;">
                <div class="progress">
                  <div class="progress-bar" id="healthstatus" style="width: 100%">
                    UNKNOWN
                  </div>
                </div>
                <p>
                  <button class="btn btn-danger btn-block" type="button" id="toggle">Toggle Health</button>
                </p>
                <p>
                  <button class="btn btn-danger btn-block" type="button" id="kill">Kill Instance</button>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row row-cards-pf">
        <div class="col-md-3 col-md-offset-3">
          <div class="card-pf">
            <div class="card-pf-heading">
              <h2 class="card-pf-title">
                Info
              </h2>
            </div>
            <div class="card-pf-body">
              <div class="table-responsive">
                <table class="datatable table table-striped table-bordered dataTable no-footer">
                  <tr role="row" class="odd">
                    <td>Pod Hostname</td>
                    <td><%= System.getenv("HOSTNAME") %></td>
                  </tr>
                  <tr role="row" class="even">
                    <td>Project</td>
                    <td><%= System.getenv("OPENSHIFT_BUILD_NAMESPACE") %></td>
                  </tr>
                  <tr role="row" class="odd">
                    <td>Used Memory</td>
                    <% int mb = 1024*1024; %>
                    <td><%= (Runtime.getRuntime().totalMemory()) / mb %> MB</td>
                  </tr>
                  <tr role="row" class="even">
                    <td>CPU Load</td>
                    <% int mb = 1024*1024; %>
                    <td><%= (Runtime.getRuntime().totalMemory()) / mb %> MB</td>
                  </tr>
                </table>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card-pf">
            <div class="card-pf-heading">
              <h2 class="card-pf-title">
                Messages
              </h2>
            </div>
            <div class="card-pf-body" id="messages">
              <div class="message-container">
                <p>Nothing to report.</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <center>
      <img src="img/buildings-front-resize-closer-sydney-cheated2-1.png" style="max-width"/>
    </center>
  </body>
  <script>

    //poll the healthcheck endpoint and update the button color appropriately
    function doPoll(){
      $.get("/ws/demo/healthcheck", function(result) {
	    $("#healthstatus").html("HEALTHY");
        $("#healthstatus").addClass("progress-bar-success").removeClass("progress-bar-danger");
      }).fail(function() {
  		$("#healthstatus").html("UNHEALTHY");
        $("#healthstatus").addClass("progress-bar-danger").removeClass("progress-bar-success");
      });
      setTimeout(doPoll,5000);
    }

    $(function() {
      // matchHeight the contents of each .card-pf and then the .card-pf itself
      $(".row-cards-pf > [class*='col'] > .card-pf .card-pf-title").matchHeight();
      $(".row-cards-pf > [class*='col'] > .card-pf > .card-pf-body").matchHeight();
      $(".row-cards-pf > [class*='col'] > .card-pf > .card-pf-footer").matchHeight();
      $(".row-cards-pf > [class*='col'] > .card-pf").matchHeight();
      // initialize tooltips
      $('[data-toggle="tooltip"]').tooltip();
    });

    $(document).ready(function() {
      // start polling
      doPoll();

      // info button
      $("#loginfo").click(function(e) {
        e.preventDefault();
        $.get("/ws/demo/log/info", function(result) {
          console.log(result);
          $("#messages .message-container p").html(result.response).show().delay(3000).fadeOut();
        }).fail(function(){
          console.log('There was a failure');
          console.log(arguments);
          $("#messages .message-container p").html("Clicking the button did not work.");
        });
      });
      // warning button
      $("#logwarning").click(function(e) {
        e.preventDefault();
        $.get("/ws/demo/log/warning", function(result) {
          console.log(result);
          $("#messages .message-container p").html(result.response).show().delay(3000).fadeOut();
        }).fail(function(){
          console.log('There was a failure');
          console.log(arguments);
          $("#messages .message-container p").html("Clicking the button did not work.");
        });
      });
      // error button
      $("#logerror").click(function(e) {
        e.preventDefault();
        $.get("/ws/demo/log/error", function(result) {
          console.log(result);
          $("#messages .message-container p").html(result.response).show().delay(3000).fadeOut();
        }).fail(function(){
          console.log('There was a failure');
          console.log(arguments);
          $("#messages .message-container p").html("Clicking the button did not work.");
        });
      });
      // load app instance
      $("#load").click(function(e) {
        e.preventDefault();
        var seconds = $("#seconds").val();
        var url = "/ws/demo/load/" + seconds;
        $.get(url, function(result) {
          console.log(result);
          $("#messages .message-container p").html(result.response).show().delay(3000).fadeOut();
        }).fail(function(){
          console.log('There was a failure');
          console.log(arguments);
          $("#messages .message-container p").html("There was a problem generating load.");
        });
      });
      // toggle button
      $("#toggle").click(function(e) {
        e.preventDefault();
        $.get("/ws/demo/togglehealth", function(result) {
            console.log(result);
            $("#messages .message-container p").html(result.response).show().delay(3000).fadeOut();
        }).fail(function(){
          console.log('There was a failure');
          console.log(arguments);
          $("#messages .message-container p").html("Clicking the button did not work.");
        });
      });
      // kill button
      $("#kill").click(function(e) {
        e.preventDefault();
        $.ajax({url:"/ws/demo/killswitch",timeout:10}).always(function(){
           console.log('Killed the remote server instance');
           $("#messages .message-container p").html("Killed the remote server instance.").show().delay(3000).fadeOut();
        });
      });
    });
  </script>
</html>
