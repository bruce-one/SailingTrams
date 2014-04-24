function setTimeout(callback, timeout) {
    var obj = Qt.createQmlObject('import QtQuick 2.0; Timer {running: false; repeat: false; interval: ' + timeout + '}', app, "setTimeout");
    obj.triggered.connect(callback);
    obj.running = true;

    return obj;
}
function clearTimeout(timer) {
    timer.running = false;
    timer.destroy(1);

    return timer;
}
