.import "window.js" as Window
var window = Window
function update(stopNo, routeNo, force){
    if(!force && app.paused) {
        console.log('Not updating because the app is paused')
        return
    }
    console.log('Updating')

    var xhr = app.xhr = new XMLHttpRequest()
    xhr.open("GET", "http://www.tramtracker.com.au/Controllers/GetNextPredictionsForStop.ashx?stopNo="+stopNo+"&routeNo="+routeNo+"&isLowFloor=false")
    xhr.onreadystatechange = function() {
        if ( xhr.readyState == xhr.DONE ) {
            if ( xhr.status == 200 ) {

                var tmp = JSON.parse(xhr.responseText)
                    , time
                    , firstTime
                    , data = []
                    , skipOpacity = typeof(listModel) !== "undefined" && listModel.count == 0

                typeof(listModel) !== "undefined" && listModel.clear()
                if(!tmp.responseObject) {
                    return
                }

                tmp.responseObject.each(function(it, i) {
                    time = Date.create(parseInt(new RegExp(/([0-9]+)/).exec(it.PredictedArrivalDateTime)[0], 10))
                    console.log('Setting time to: ' + time.relative())
                    //delegate.children['0'].text = time.relative()
                    data.push({name:time.relative(), time: time, routeNo: routeNo != 0 ? '' : it.HeadBoardRouteNo})

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
                if(typeof(coverLabel) !== "undefined") {
                    coverLabel.opacity = 0
                    window.setTimeout(function(){
                        coverLabel.opacity = 1
                    }, 500)
                }
                if(typeof(listOpacity) !== "undefined" && !skipOpacity) {
                    window.setTimeout(function(){
                        listOpacity = 0.4
                    }, 250)
                    window.setTimeout(function(){
                        listOpacity = 1
                    }, 500)
                }
            }
        }
    }
    xhr.send()
}
