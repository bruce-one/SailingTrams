.import QtQuick.LocalStorage 2.0 as Sql
function update(){
    console.log('Updating')
    app.db = app.db || Sql.LocalStorage.openDatabaseSync("SailingTramsDB", "", "SailingTrams", 1000)

    app.db.version === '' && app.db.changeVersion('', '1.0', function(tx){
        tx.executeSql('CREATE TABLE IF NOT EXISTS UserStops(stopNo NUM, routeNo NUM, PRIMARY KEY(stopNo, routeNo));')
        app.db.version = '1.0'
    })
    app.db.version === '1.0' && app.db.changeVersion('1.0', '2.0', function(tx){
        tx.executeSql('ALTER TABLE UserStops ADD nickname TEXT;')
        app.db.version = '2.0'
    })
    app.db.transaction(function(tx) {
        var rs
        rs = tx.executeSql('SELECT * FROM UserStops;')
        listModel.clear()
        for(var i = 0, l = rs.rows.length; i < l; i++) {
            console.log(rs.rows.item(i).nickname)
            listModel.append({name: (rs.rows.item(i).nickname ? rs.rows.item(i).nickname : qsTr("Stop ") + rs.rows.item(i).stopNo+''), stopNo: rs.rows.item(i).stopNo, routeNo: rs.rows.item(i).routeNo})
        }
    })
}
