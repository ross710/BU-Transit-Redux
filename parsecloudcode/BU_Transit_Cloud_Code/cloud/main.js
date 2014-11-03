Parse.Cloud.job('ArrivalEstimateNotificationBackgroundJob', function(req, status) {
    Parse.Cloud.useMasterKey();

    var stops;
    var arrivalEstimates;
    Parse.Cloud.httpRequest({
        url: 'https://transloc-api-1-2.p.mashape.com/stops.json?agencies=bu',
        method: 'GET',
        headers: {
            'X-Mashape-Key': 'uZv7A5PnaZmshlh9APd2SJKQCXfmp1ubISCjsnFIBzMJCeJJru'
        },
        success: function(httpResponse) {
            stops = httpResponse.data.data;
        },
        error: function(httpResponse) {
            status.error(httpResponse.text);
            return;
        }
    }).then(function() {
        Parse.Cloud.httpRequest({
            url: 'https://transloc-api-1-2.p.mashape.com/arrival-estimates.json?agencies=bu',
            method: 'GET',
            headers: {
                'X-Mashape-Key': 'uZv7A5PnaZmshlh9APd2SJKQCXfmp1ubISCjsnFIBzMJCeJJru'
            },
            success: function(httpResponse) {
                arrivalEstimates = httpResponse.data.data;
            },
            error: function(httpResponse) {
                status.error(httpResponse.text);
                return;
            }
        }).then(function() {
            //Now have all data
            var promises = [];

            //loop through all stops
            for (var i = 0; i < arrivalEstimates.length; i++) {


                var arrivalEstimate = arrivalEstimates[i];
                var stop_id = arrivalEstimate.stop_id;
                var arrivals = arrivalEstimate["arrivals"];

                //Setup message 
                var message = "Next bus arrives at ";
                message += stopNameForStopId(stop_id, stops) + " in";

                //get array of the minutes till the next bus
                var minutesTillArrival = getMinutesTillArrival(arrivals);

                //If arrival
                if (arrivals.length > 0) {
                    //Wait for installations to finish
                    promises.push(sendNotificationsToEveryoneWhoWants(stop_id, minutesTillArrival, message));
                } else {
                    //just resolve it
                }
            }
            Parse.Promise.when(promises).then(function() {
                status.success("Success");
            });
        });

    });

});


var sendNotificationsToEveryoneWhoWants = function(stop_id, minutesTillArrival, message) {
    var installationsQ = new Parse.Query(Parse.Installation);
    installationsQ.equalTo('stopId', stop_id);
    installationsQ.equalTo('wantsToBeNotified', true);
    installationsQ.equalTo("notificationTimes", minutesTillArrival[0]);
    
    message += " " + minutesTillArrival[0] + " min";
    
    console.log(message + " " + JSON.stringify(installationsQ));
    return Parse.Push.send({
        where: installationsQ,
        data: {
            alert: message
        }
    });
}


var getMinutesTillArrival = function(arrivals) {
    var date = new Date();
    var minutesTillArrival = [];
    for (var j = 0; j < arrivals.length; j++) {
        var arrival = arrivals[j];
        var arrival_at = new Date(arrival["arrival_at"]);

        var minutes = Math.round((arrival_at - date) / 60000);
        minutesTillArrival.push(minutes);
        //      if (j > 0) {
        //          message += ",";
        //      }
        //      message += " " + minutes + " min";
    }
    return minutesTillArrival;
}

var stopNameForStopId = function(stopId, stopArray) {
    for (var i = 0; i < stopArray.length; i++) {

        if (stopId == stopArray[i]["stop_id"]) {
            return stopArray[i]["name"];
        }
    }
    return stopId;
}