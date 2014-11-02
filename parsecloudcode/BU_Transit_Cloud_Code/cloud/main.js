Parse.Cloud.job('ArrivalEstimateNotificationBackgroundJob',function(req,status){

  var taskUrl = 'https://transloc-api-1-2.p.mashape.com/arrival-estimates.json?agencies=12%2C16&callback=call&routes=4000421%2C4000592%2C4005122&stops=4002123%2C4023414%2C4021521';
  var response;
  Parse.Cloud.httpRequest({
      url: taskUrl,
      method: 'GET',
      headers:{
          'X-Mashape-Key': 'uZv7A5PnaZmshlh9APd2SJKQCXfmp1ubISCjsnFIBzMJCeJJru'
      },
      success: function (httpResponse) {
          response = httpResponse;
      },
      error:function (httpResponse) {
          status.error(httpResponse.text);
          return;
      }
  }).then(function () {
    console.log(response.text);
    var data = response.data.data;
    
    
    
    console.log("Data " + JSON.stringify(data));
    
    status.success("Success");

  });
  
  

});
