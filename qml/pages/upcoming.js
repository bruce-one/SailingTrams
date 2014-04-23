function update(stopNo, routeNo, force){
    if(!force && app.paused) {
        console.log('Not updating because the app is paused')
        return
    }

    var xhr = app.xhr = new XMLHttpRequest()

    xhr.open("GET", "http://www.tramtracker.com/Controllers/GetNextPredictionsForStop.ashx?stopNo="+stopNo+"&routeNo="+routeNo+"&isLowFloor=false")
    xhr.onreadystatechange = function() {
        if ( xhr.readyState == xhr.DONE ) {
            if ( xhr.status == 200 ) {

                var tmp = JSON.parse(xhr.responseText)
                    , time
                    , firstTime
                    , data = []

                typeof(listModel) !== "undefined" && listModel.clear()

                tmp.responseObject.each(function(it, i) {
                    time = Date.create(parseInt(new RegExp(/([0-9]+)/).exec(it.PredictedArrivalDateTime)[0], 10))
                    console.log('Setting time to: ' + time.relative())
                    //delegate.children['0'].text = time.relative()
                    data.push({name:time.relative(), time: time})

                })
                data = data.sortBy(function(it){
                    return it.time
                })
                firstTime = data.first() ? data.first().time : ''
                typeof(listModel) !== "undefined" && data.each(function(it) { listModel.append(it) })

                app.stopNo = stopNo
                app.routeNo = routeNo
                app.coverStop = stopNo
                app.coverTime = Date.create().minutesUntil(firstTime) + 'm'
            }
        }
    }
    xhr.send()
}
