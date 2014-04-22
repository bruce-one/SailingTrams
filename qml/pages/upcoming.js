function update(){
    var xhr = new XMLHttpRequest()
    xhr.open("GET", "http://www.tramtracker.com/Controllers/GetNextPredictionsForStop.ashx?stopNo=2022&routeNo=72&isLowFloor=false")
    xhr.onreadystatechange = function() {
        if ( xhr.readyState == xhr.DONE ) {
            if ( xhr.status == 200 ) {
                var tmp = JSON.parse(xhr.responseText)
                    , time

                listModel.clear()
                tmp.responseObject.each(function(it, i) {
                    time = Date.create(parseInt(new RegExp(/([0-9]+)/).exec(it.PredictedArrivalDateTime)[0], 10))
                    console.log('Setting time to: ' + time.relative())
                    //delegate.children['0'].text = time.relative()
                    listModel.append({name:time.relative()})
                })

            }
        }
    }
    xhr.send()
}
